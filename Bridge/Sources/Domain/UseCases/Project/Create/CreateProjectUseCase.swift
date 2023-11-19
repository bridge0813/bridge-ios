//
//  CreateProjectUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/20.
//

import RxSwift

protocol CreateProjectUseCase {
    func create(with project: CreateProject) -> Observable<String>
}

final class DefaultCreateProjectUseCase: CreateProjectUseCase {
    
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func create(with project: CreateProject) -> Observable<String> {
        projectRepository.createProject(with: project)
    }
}
