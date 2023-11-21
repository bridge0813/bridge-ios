//
//  SignInViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/08.
//

import AuthenticationServices
import RxSwift

final class SignInViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let dismissButtonTapped: Observable<Void>
        let signInWithAppleButtonTapped: Observable<Void>
    }
    
    struct Output { }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    weak var coordinator: AuthCoordinator?
    private let signInUseCase: SignInUseCase
    
    // MARK: - Init
    init(coordinator: AuthCoordinator, signInUseCase: SignInUseCase) {
        self.coordinator = coordinator
        self.signInUseCase = signInUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        input.dismissButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.finish()
            })
            .disposed(by: disposeBag)
        
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
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .signUpNeeded:
                    owner.coordinator?.showSetFieldViewController()
                    
                case .success:          
                    owner.coordinator?.finish()
                    
                case .failure: 
                    owner.coordinator?.showErrorAlert(configuration: .defaultError)
                }
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}

private extension SignInViewModel {
    func mapToUserCredentials(_ authorization: ASAuthorization) -> UserCredentials {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return UserCredentials.onError
        }
        
        let userIdentifier = appleIDCredential.user
        let userName = appleIDCredential.fullName?.familyName
        let givenName = appleIDCredential.fullName?.givenName
        let identityToken = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8)
        let authorizationCode = String(data: appleIDCredential.authorizationCode ?? Data(), encoding: .utf8)
        
        return UserCredentials(
            id: userIdentifier,
            userName: userName,
            givenName: givenName,
            identityToken: identityToken,
            authorizationCode: authorizationCode
        )
    }
}
