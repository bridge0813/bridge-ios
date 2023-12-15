//
//  FetchProjectDetailUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/13.
//

import RxSwift

/// 지원자의 고유 ID로 식별을 위해 사용됨
typealias SignInNeeded = Bool

protocol FetchProjectDetailUseCase {
    func fetchProjectDetail(with projectID: Int) -> Observable<(Project, SignInNeeded)>
}

final class DefaultFetchProjectDetailUseCase: FetchProjectDetailUseCase {
    
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func fetchProjectDetail(with projectID: Int) -> Observable<(Project, SignInNeeded)> {
        projectRepository.fetchProjectDetail(with: projectID)
    }
}
