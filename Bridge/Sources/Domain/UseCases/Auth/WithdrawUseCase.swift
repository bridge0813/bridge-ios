//
//  WithdrawUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 12/12/23.
//

import RxSwift

protocol WithdrawUseCase {
    func withdraw() -> Observable<Void>
}

final class DefaultWithdrawUseCase: WithdrawUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func withdraw() -> Observable<Void> {
        authRepository.withdraw()
    }
}
