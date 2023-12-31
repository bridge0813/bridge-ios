//
//  SignInUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/13.
//

import RxSwift

protocol SignInUseCase {
    func signInWithApple(credentials: UserCredentials) -> Observable<SignInResult>
}

final class DefaultSignInUseCase: SignInUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func signInWithApple(credentials: UserCredentials) -> Observable<SignInResult> {
        authRepository.signInWithApple(credentials: credentials)
            .map { isRegistered in
                isRegistered ? .success : .signUpNeeded
            }
            .catchAndReturn(.failure)
    }
}
