//
//  MockProjectRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/17.
//

import RxSwift

final class MockProjectRepository: ProjectRepository {
    // MARK: - Methods
    func fetchAllProjects() -> Observable<[ProjectPreview]> {
        .just(ProjectPreviewDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchHotProjects() -> Observable<[ProjectPreview]> {
        .just(ProjectPreviewDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchProjectDetail(with projectID: Int) -> Observable<Project> {
        .just(ProjectDetailDTO.projectDetailTest.toEntity())
    }
    
    func create(with project: Project) -> Observable<Int> {
        .just(0)
    }
}