//
//  CancelApplicationUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/13/23.
//

import RxSwift

/// 지원취소
protocol CancelApplicationUseCase {
    func cancel(projectID: Int) -> Observable<Int>
}

final class DefaultCancelApplicationUseCase: CancelApplicationUseCase {
    
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func cancel(projectID: Int) -> Observable<Int> {
        projectRepository.cancel(projectID: projectID)
    }
}
