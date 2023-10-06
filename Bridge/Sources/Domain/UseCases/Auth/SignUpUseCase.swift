//
//  SignUpUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 10/6/23.
//

import RxSwift

protocol SignUpUseCase {
    func signUp(selectedFields: Set<String>) -> Single<Void>
}

final class DefaultSignUpUseCase: SignUpUseCase {

    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func signUp(selectedFields: Set<String>) -> Single<Void> {
        authRepository.signUp(selectedFields: selectedFields.map { $0 })
    }
}
