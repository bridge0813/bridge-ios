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
        .just(ProjectPreviewResponseDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchProjectsByField(for field: String) -> Observable<[ProjectPreview]> {
        .just(ProjectPreviewResponseDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchHotProjects() -> Observable<[ProjectPreview]> {
        .just(ProjectPreviewResponseDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchDeadlineProjects() -> Observable<[ProjectPreview]> {
        .just(ProjectPreviewResponseDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchProjectDetail(with projectID: Int) -> Observable<Project> {
        .just(ProjectDetailDTO.projectDetailTest.toEntity())
    }
    
    func create(project: Project) -> Observable<Int> {
        .just(0)
    }
}
