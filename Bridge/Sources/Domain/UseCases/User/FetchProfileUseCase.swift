//
//  FetchProfileUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/30/23.
//

import RxSwift

protocol FetchProfileUseCase {
    func fetch() -> Observable<Profile>
}

final class DefaultFetchProfileUseCase: FetchProfileUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetch() -> Observable<Profile> {
        userRepository.fetchProfile()
    }
}
