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
        .just(ProjectDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchHotProjects() -> Observable<[Project]> {
        .just(ProjectDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchProjectDetail(with projectID: Int) -> Observable<ProjectDetail> {
        .just(ProjectDetailDTO.projectDetailTest.toEntity())
    }
}
