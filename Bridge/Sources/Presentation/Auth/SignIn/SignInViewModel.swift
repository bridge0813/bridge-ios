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
    
    struct Output {
        
    }
    
    let disposeBag = DisposeBag()
    
    weak var coordinator: AuthCoordinator?
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        input.signInWithAppleButtonTapped
            .flatMap {
                ASAuthorizationAppleIDProvider().rx.signIn()
            }
            .withUnretained(self)
            .subscribe(
                onNext: { owner, authorization in
                    owner.coordinator?.showSelectFieldViewController()  // 테스트용
                },
                onError: { _ in
                    // error handling
                }
            )
            .disposed(by: disposeBag)
        
        return Output()
    }
}

extension SignInViewModel {
//    func foo() {
//        let userIdentifier = appleIDCredential.user
//        let userName = appleIDCredential.fullName?.familyName ?? "홍"
//        let givenName = appleIDCredential.fullName?.givenName ?? "길동"
//        let fullName = userName + givenName
//        let authorizationCode = appleIDCredential.authorizationCode
//        let identityToken = appleIDCredential.identityToken
//    }
}
