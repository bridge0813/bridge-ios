//
//  FetchProfileUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/30/23.
//

import RxSwift

protocol FetchProfileUseCase {
    func fetchProfile(otherUserID: String?) -> Observable<Profile>
    func fetchProfilePreview() -> Observable<ProfilePreview>
}

extension FetchProfileUseCase {
    // otherUserID가 있을 경우, 다른 유저의 프로필
    // 없을 경우, 내 프로필
    func fetchProfile(otherUserID: String? = nil) -> Observable<Profile> {
        fetchProfile(otherUserID: otherUserID)
    }
}

final class DefaultFetchProfileUseCase: FetchProfileUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetchProfile(otherUserID: String?) -> Observable<Profile> {
        userRepository.fetchProfile(otherUserID: otherUserID)
    }
    
    func fetchProfilePreview() -> Observable<ProfilePreview> {
        userRepository.fetchProfilePreview()
    }
}
