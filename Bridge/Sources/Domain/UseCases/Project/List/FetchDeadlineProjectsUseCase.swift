//
//  FetchDeadlineProjectsUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/27.
//

import RxSwift

protocol FetchDeadlineProjectsUseCase {
    func fetchProjects() -> Observable<[ProjectPreview]>
}

final class DefaultFetchDeadlineProjectsUseCase: FetchDeadlineProjectsUseCase {
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func fetchProjects() -> Observable<[ProjectPreview]> {
        projectRepository.fetchHotProjects()
    }
}
