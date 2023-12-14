//
//  SignOutUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 12/12/23.
//

import RxSwift

protocol SignOutUseCase {
    func signOut() -> Observable<Void>
}

final class DefaultSignOutUseCase: SignOutUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func signOut() -> Observable<Void> {
        authRepository.signOut()
    }
}
