//
//  BookmarkUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2023/12/02.
//

import RxSwift

protocol BookmarkUseCase {
    func bookmark(projectID: Int) -> Observable<Void>
}

final class DefaultBookmarkUseCase: BookmarkUseCase {
    
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func bookmark(projectID: Int) -> Observable<Void> {
        projectRepository.bookmark(projectID: projectID)
    }
}
