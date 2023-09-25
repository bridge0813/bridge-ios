//
//  SignInViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/08.
//

import AuthenticationServices
import RxSwift

final class SignInViewModel: ViewModelType {
    
    struct Input {
        let signInWithAppleButtonTapped: Observable<Void>
    }
    
    struct Output { }
    
    let disposeBag = DisposeBag()
    
    weak var coordinator: AuthCoordinator?
    private let signInUseCase: SignInUseCase
    
    init(coordinator: AuthCoordinator, signInUseCase: SignInUseCase) {
        self.coordinator = coordinator
        self.signInUseCase = signInUseCase
    }
    
    func transform(input: Input) -> Output {
        input.signInWithAppleButtonTapped
            .flatMap {
                ASAuthorizationAppleIDProvider().rx.requestAuthorizationWithAppleID()
            }
            .withUnretained(self)
            .map { owner, authorization in
                owner.mapToUserCredentials(authorization)
            }
            .withUnretained(self)
            .flatMap { owner, credentials in
                owner.signInUseCase.signInWithApple(credentials: credentials)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(
                with: self,
                onNext: { owner, result in
                    switch result {
                    case .success:
                        owner.coordinator?.finish()
                        
                    case .needRefresh:
                        // refresh token 넣어서 다시 요청
                        print("need refresh")
                        
                    case .needSignUp:
                        owner.coordinator?.showSelectFieldViewController()
                        
                    case .failure:
                        print("fail")
                        // error handling ...
                    }
                }
            )
            .disposed(by: disposeBag)
        
        return Output()
    }
}

private extension SignInViewModel {
    func mapToUserCredentials(_ authorization: ASAuthorization) -> UserCredentials {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential
        else { return UserCredentials.onError }
        
        let userIdentifier = appleIDCredential.user
        let userName = appleIDCredential.fullName?.familyName ?? ""
        let givenName = appleIDCredential.fullName?.givenName ?? ""
        let fullName = userName + givenName
        let identityToken = appleIDCredential.identityToken
        let authorizationCode = appleIDCredential.authorizationCode
        
        return UserCredentials(
            id: userIdentifier,
            name: fullName,
            identityToken: identityToken,
            authorizationCode: authorizationCode
        )
    }
}
