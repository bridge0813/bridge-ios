//
//  FetchProfileUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/30/23.
//

import RxSwift

protocol FetchProfileUseCase {
    func fetchMyProfile() -> Observable<Profile>
    func fetchOtherUserProfile(userID: Int) -> Observable<Profile>
}

final class DefaultFetchProfileUseCase: FetchProfileUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetchMyProfile() -> Observable<Profile> {
        userRepository.fetchMyProfile()
    }
    
    func fetchOtherUserProfile(userID: Int) -> Observable<Profile> {
        userRepository.fetchOtherUserProfile(userID: userID)
    }
}
