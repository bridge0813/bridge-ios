//
//  DeleteProjectUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/11/23.
//

import RxSwift

protocol DeleteProjectUseCase {
    func delete(projectID: Int) -> Observable<Int>
}

final class DefaultDeleteProjectUseCase: DeleteProjectUseCase {
    
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func delete(projectID: Int) -> Observable<Int> {
        projectRepository.delete(projectID: projectID)
    }
}
