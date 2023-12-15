//
//  FetchAppliedProjectsUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/8/23.
//

import RxSwift

protocol FetchAppliedProjectsUseCase {
    func fetchProjects() -> Observable<[ProjectPreview]>
}

final class DefaultFetchAppliedProjectsUseCase: FetchAppliedProjectsUseCase {
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func fetchProjects() -> Observable<[ProjectPreview]> {
        projectRepository.fetchAppliedProjects()
    }
}
