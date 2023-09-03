//
//  File.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/03.
//

import RxSwift

protocol FetchHotProjectsUseCase {
    func execute() -> Observable<[HotProject]>
}

final class DefaultFetchHotProjectsUseCase: FetchHotProjectsUseCase {
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func execute() -> Observable<[HotProject]> {
        projectRepository.fetchHotProjects()
    }
}
