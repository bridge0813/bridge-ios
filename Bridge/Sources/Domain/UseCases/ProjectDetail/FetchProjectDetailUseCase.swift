//
//  FetchProjectDetailUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/13.
//

import RxSwift

protocol FetchProjectDetailUseCase {
    func fetchProject(with projectID: Int) -> Observable<Project>
}

final class DefaultFetchProjectDetailUseCase: FetchProjectDetailUseCase {
    
    private let projectDetailRepository: ProjectDetailRepository
    
    init(projectDetailRepository: ProjectDetailRepository) {
        self.projectDetailRepository = projectDetailRepository
    }
    
    func fetchProject(with projectID: Int) -> Observable<Project> {
        projectDetailRepository.fetchProject(with: projectID)
    }
}
