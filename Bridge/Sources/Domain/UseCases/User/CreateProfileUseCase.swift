//
//  CreateProfileUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 1/13/24.
//

import RxSwift

protocol CreateProfileUseCase {
    func create(_ profile: Profile) -> Observable<Void>
}

final class DefaultCreateProfileUseCase: CreateProfileUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func create(_ profile: Profile) -> Observable<Void> {
        userRepository.createProfile(profile)
    }
}
