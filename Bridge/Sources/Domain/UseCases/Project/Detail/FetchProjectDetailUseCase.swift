//
//  FetchProjectDetailUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/13.
//

import RxSwift

protocol FetchProjectDetailUseCase {
    func fetchProjectDetail(with projectID: Int) -> Observable<Project>
}

final class DefaultFetchProjectDetailUseCase: FetchProjectDetailUseCase {
    
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func fetchProjectDetail(with projectID: Int) -> Observable<Project> {
        projectRepository.fetchProjectDetail(with: projectID)
    }
}
