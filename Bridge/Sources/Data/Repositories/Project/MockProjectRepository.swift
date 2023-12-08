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
        .just(ProjectPreviewResponseDTO.projectByFieldTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchHotProjects() -> Observable<[ProjectPreview]> {
        .just(HotProjectResponseDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchDeadlineProjects() -> Observable<[ProjectPreview]> {
        .just(DeadlineProjectResponseDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchProjectDetail(with projectID: Int) -> Observable<Project> {
        .just(ProjectDetailDTO.projectDetailTest.toEntity())
    }
    
    func fetchApplyProjects() -> Observable<[ProjectPreview]> {
        .just(ApplyProjectResponseDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func create(project: Project) -> Observable<Int> {
        .just(0)
    }
    
    func bookmark(projectID: Int) -> Observable<Int> {
        .just(projectID)
    }
}
