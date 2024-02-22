//
//  UpdateProjectUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2/11/24.
//

import RxSwift

protocol UpdateProjectUseCase {
    func update(project: Project) -> Observable<Void>
}

final class DefaultUpdateProjectUseCase: UpdateProjectUseCase {
    
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func update(project: Project) -> Observable<Void> {
        projectRepository.update(project: project)
    }
}
