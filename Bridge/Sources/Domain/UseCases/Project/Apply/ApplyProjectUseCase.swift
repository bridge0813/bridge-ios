//
//  ApplyProjectUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/17/23.
//

import RxSwift

/// 모집글의 지원을 거절하는 UseCase
protocol ApplyProjectUseCase {
    func apply(projectID: Int) -> Observable<Void>
}

final class DefaultApplyProjectUseCase: ApplyProjectUseCase {
    
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func apply(projectID: Int) -> Observable<Void> {
        projectRepository.apply(projectID: projectID)
    }
}
