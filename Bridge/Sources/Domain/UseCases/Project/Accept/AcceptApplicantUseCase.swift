//
//  AcceptApplicantUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/12/23.
//

import RxSwift

/// 모집글의 지원을 수락하는 UseCase
protocol AcceptApplicantUseCase {
    func accept(projectID: Int, userID: Int) -> Observable<Int>
}

final class DefaultAcceptApplicantUseCase: AcceptApplicantUseCase {
    
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func accept(projectID: Int, userID: Int) -> Observable<Int> {
        projectRepository.accept(projectID: projectID, userID: userID)
    }
}
