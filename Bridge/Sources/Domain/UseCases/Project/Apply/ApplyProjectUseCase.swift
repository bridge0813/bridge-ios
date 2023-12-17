//
//  ApplyProjectUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/17/23.
//

import RxSwift

/// 모집글 지원
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
