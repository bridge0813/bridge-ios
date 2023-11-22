//
//  ObserveProjectsUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import RxSwift

protocol FetchAllProjectsUseCase {
    func execute() -> Observable<[ProjectPreview]>
}

final class DefaultFetchAllProjectsUseCase: FetchAllProjectsUseCase {
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func execute() -> Observable<[ProjectPreview]> {
        projectRepository.fetchAllProjects()
    }
}
