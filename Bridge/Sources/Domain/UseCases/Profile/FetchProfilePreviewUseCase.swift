//
//  FetchProfilePreviewUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/25.
//

import RxSwift

protocol FetchProfilePreviewUseCase {
    func fetchProfilePreview() -> Observable<ProfilePreview>
}

final class DefaultFetchProfilePreviewUseCase: FetchProfilePreviewUseCase {
    
    private let profileRepository: ProfileRepository
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }
    
    func fetchProfilePreview() -> Observable<ProfilePreview> {
        profileRepository.fetchProfilePreview()
    }
}
