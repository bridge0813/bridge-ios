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
    
    func fetchProjectDetail(with projectID: Int) -> Observable<(Project, SignInNeeded)> {
        .just((ProjectDetailDTO.testData.toEntity(), false))
//        .error(NetworkError.unknown)
    }
    
    func fetchAppliedProjects() -> Observable<[ProjectPreview]> {
        .just(AppliedProjectResponseDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchMyProjects() -> Observable<[ProjectPreview]> {
        .just(MyProjectResponseDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func create(project: Project) -> Observable<Int> {
        .just(0)
    }
    
    func bookmark(projectID: Int) -> Observable<Int> {
        .just(projectID)
    }
    
    func delete(projectID: Int) -> Observable<Int> {
        .just(projectID)
    }
    
    func cancel(projectID: Int) -> Observable<Int> {
        .just(projectID)
    }
    
    func accept(projectID: Int, applicantID: Int) -> Observable<Int> {
        .just(applicantID)
    }
    
    func reject(projectID: Int, applicantID: Int) -> Observable<Int> {
        .just(applicantID)
    }
    
    func apply(projectID: Int) -> Observable<Void> {
        .just(())
    }
    
    func close(projectID: Int) -> Observable<Int> {
        .just(projectID)
    }
}
