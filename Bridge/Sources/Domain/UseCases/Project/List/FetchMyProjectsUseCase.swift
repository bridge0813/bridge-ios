//
//  FetchRecruitmentProjectsUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/9/23.
//

import RxSwift

protocol FetchMyProjectsUseCase {
    func fetchProjects() -> Observable<[ProjectPreview]>
}

final class DefaultFetchRecruitmentProjectsUseCase: FetchMyProjectsUseCase {
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func fetchProjects() -> Observable<[ProjectPreview]> {
        projectRepository.fetchRecruitmentProjects()
    }
}
