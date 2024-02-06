//
//  FetchFilteredProjectsUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2/4/24.
//

import RxSwift

protocol FetchFilteredProjectsUseCase {
    func fetch(filterBy fieldTechStack: FieldTechStack) -> Observable<[ProjectPreview]>
}

final class DefaultFetchFilteredProjectsUseCase: FetchFilteredProjectsUseCase {
    
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func fetch(filterBy fieldTechStack: FieldTechStack) -> Observable<[ProjectPreview]> {
        projectRepository.fetchFilteredProjects(filterBy: fieldTechStack)
    }
}
