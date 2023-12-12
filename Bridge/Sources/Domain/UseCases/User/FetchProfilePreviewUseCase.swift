//
//  FetchProfilePreviewUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/25.
//  Edited by 정호윤 on 2023/12/12.

import RxSwift

protocol FetchProfilePreviewUseCase {
    func fetchProfilePreview() -> Observable<ProfilePreview>
}

final class DefaultFetchProfilePreviewUseCase: FetchProfilePreviewUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetchProfilePreview() -> Observable<ProfilePreview> {
        userRepository.fetchProfilePreview()
    }
}
