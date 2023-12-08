//
//  FetchApplyProjectsUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/8/23.
//

import RxSwift

protocol FetchApplyProjectsUseCase {
    func fetchProjects() -> Observable<[ProjectPreview]>
}

final class DefaultFetchApplyProjectsUseCase: FetchApplyProjectsUseCase {
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func fetchProjects() -> Observable<[ProjectPreview]> {
        projectRepository.fetchApplyProjects()
    }
}
