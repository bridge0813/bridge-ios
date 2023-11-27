//
//  File.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/03.
//

import RxSwift

protocol FetchHotProjectsUseCase {
    func fetchProjects() -> Observable<[ProjectPreview]>
}

final class DefaultFetchHotProjectsUseCase: FetchHotProjectsUseCase {
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func fetchProjects() -> Observable<[ProjectPreview]> {
        projectRepository.fetchHotProjects()
    }
}
