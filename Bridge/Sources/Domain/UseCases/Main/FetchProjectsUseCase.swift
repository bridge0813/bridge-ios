//
//  ObserveProjectsUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import RxSwift

protocol FetchProjectsUseCase {
    func execute() -> Observable<[Project]>
}

final class DefaultFetchProjectsUseCase: FetchProjectsUseCase {
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func execute() -> Observable<[Project]> {
        projectRepository.observeProjects()
    }
}
