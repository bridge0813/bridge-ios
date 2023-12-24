//
//  FetchBookmarkedProjectsUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 12/23/23.
//

import RxSwift

protocol FetchBookmarkedProjectsUseCase {
    func fetch() -> Observable<[BookmarkedProject]>
}

final class DefaultFetchBookmarkedProjectsUseCase: FetchBookmarkedProjectsUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetch() -> Observable<[BookmarkedProject]> {
        userRepository.fetchBookmarkedProjects()
    }
}
