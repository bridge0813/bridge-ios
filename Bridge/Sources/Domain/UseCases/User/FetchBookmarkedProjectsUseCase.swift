//
//  FetchBookmarkedProjectsUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 12/23/23.
//

import RxSwift

protocol FetchBookmarkedProjectsUseCase {
    func fetchBookmarkedProjects() -> Observable<[BookmarkedProject]>
}

final class DefaultFetchBookmarkedProjectsUseCase: FetchBookmarkedProjectsUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetchBookmarkedProjects() -> Observable<[BookmarkedProject]> {
        userRepository.fetchBookmarkedProjects()
    }
}
