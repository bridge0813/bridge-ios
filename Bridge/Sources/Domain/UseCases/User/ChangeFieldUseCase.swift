//
//  ChangeFieldUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 12/22/23.
//

import RxSwift

protocol ChangeFieldUseCase {
    func changeField(selectedFields: [String]) -> Observable<Void>
}

final class DefaultChangeFieldUseCase: ChangeFieldUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func changeField(selectedFields: [String]) -> Observable<Void> {
        userRepository.changeField(selectedFields: selectedFields.map { $0.uppercased() })
    }
}
