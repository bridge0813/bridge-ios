//
//  CloseProjectUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/17/23.
//

import RxSwift

/// 모집글 마감
protocol CloseProjectUseCase {
    func close(projectID: Int) -> Observable<Int>
}

final class DefaultCloseProjectUseCase: CloseProjectUseCase {
    
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func close(projectID: Int) -> Observable<Int> {
        projectRepository.close(projectID: projectID)
    }
}
