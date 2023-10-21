//
//  SignUpUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 10/6/23.
//

import RxSwift

protocol SignUpUseCase {
    func signUp(selectedFields: Set<String>) -> Observable<SignUpResult>
}

final class DefaultSignUpUseCase: SignUpUseCase {

    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func signUp(selectedFields: Set<String>) -> Observable<SignUpResult> {
        authRepository.signUp(selectedFields: selectedFields.map { $0 })
    }
}
