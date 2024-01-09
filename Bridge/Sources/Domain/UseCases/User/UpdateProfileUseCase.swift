//
//  UpdateProfileUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 1/9/24.
//

import RxSwift

protocol UpdateProfileUseCase {
    func update(_ profile: Profile) -> Observable<Void>
}

final class DefaultUpdateProfileUseCase: UpdateProfileUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func update(_ profile: Profile) -> Observable<Void> {
        userRepository.updateProfile(profile)
    }
}
