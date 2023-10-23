//
//  MockProjectRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/17.
//

import RxSwift

final class MockProjectRepository: ProjectRepository {
    // MARK: - Methods
    func fetchAllProjects() -> Observable<[Project]> {
        .just(ProjectDTO.projectTestArray.compactMap { $0.toModel() })
    }
    
    func fetchHotProjects() -> Observable<[Project]> {
        .just(ProjectDTO.projectTestArray.compactMap { $0.toModel() })
    }
}
