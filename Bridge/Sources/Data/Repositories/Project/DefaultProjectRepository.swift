//
//  DefaultProjectRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation
import RxSwift

final class DefaultProjectRepository: ProjectRepository {
    // MARK: - Properties
    private let networkService: NetworkService
    private let tokenStorage: TokenStorage
    
    // MARK: - Initializer
    init(networkService: NetworkService, tokenStorage: TokenStorage = KeychainTokenStorage()) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
    
    // MARK: - Fetch
    // 전체 모집글 목록 가져오기
    func fetchAllProjects() -> Observable<[ProjectPreview]> {
        return networkService.request(to: ProjectEndpoint.fetchAllProjects, interceptor: nil)
            .decode(type: [ProjectPreviewResponseDTO].self, decoder: JSONDecoder())
            .map { projectPreviewDTOs in
                projectPreviewDTOs.map { $0.toEntity() }
            }
    }
    
    // 특정 분야에 맞는 모집글 목록 가져오기
    func fetchProjectsByField(for field: String) -> Observable<[ProjectPreview]> {
        let fieldRequestDTO = FieldRequestDTO(field: field)
        let fetchProjectsEndPoint = ProjectEndpoint.fetchProjectsByField(requestDTO: fieldRequestDTO)
        
        return networkService.request(to: fetchProjectsEndPoint, interceptor: nil)
            .decode(type: [ProjectPreviewResponseDTO].self, decoder: JSONDecoder())
            .map { projectPreviewDTOs in
                projectPreviewDTOs.map { $0.toEntity() }
            }
    }
    
    // 인기 모집글 목록 가져오기
    func fetchHotProjects() -> Observable<[ProjectPreview]> {
        return networkService.request(to: ProjectEndpoint.fetchHotProjects, interceptor: nil)
            .decode(type: [HotProjectResponseDTO].self, decoder: JSONDecoder())
            .map { hotProjectDTOs in
                hotProjectDTOs.map { $0.toEntity() }
            }
    }
    
    // 마감임박 모집글 목록 가져오기
    func fetchDeadlineProjects() -> Observable<[ProjectPreview]> {
        return networkService.request(to: ProjectEndpoint.fetchDeadlineProjects, interceptor: nil)
            .decode(type: [DeadlineProjectResponseDTO].self, decoder: JSONDecoder())
            .map { deadlineProjectDTOs in
                deadlineProjectDTOs.map { $0.toEntity() }
            }
    }
    
    // 모집글 상세정보 가져오기
    func fetchProjectDetail(with projectID: Int) -> Observable<(Project, SignInNeeded)> {
        let userID = tokenStorage.get(.userID)
        let projectIDDTO = ProjectIDDTO(projectID: projectID)  // 조회 할 모집글의 request DTO
        let fetchProjectDetailEndpoint = ProjectEndpoint.fetchProjectDetail(requestDTO: projectIDDTO, userID: userID)
        
        return networkService.request(to: fetchProjectDetailEndpoint, interceptor: nil)
            .decode(type: ProjectDetailDTO.self, decoder: JSONDecoder())
            .map { dto in
                return (dto.toEntity(), userID.isEmpty)
            }
    }
    
    // 지원한 모집글 목록 가져오기
    func fetchAppliedProjects() -> Observable<[ProjectPreview]> {
        .just(AppliedProjectResponseDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchMyProjects() -> Observable<[ProjectPreview]> {
        .just(MyProjectResponseDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    // MARK: - Create
    func create(project: Project) -> Observable<Int> {
        let createProjectDTO = convertToDTO(from: project)
        let createProjectEndpoint = ProjectEndpoint.create(requestDTO: createProjectDTO)
        
        return networkService.request(to: createProjectEndpoint, interceptor: AuthInterceptor())
            .decode(type: ProjectIDDTO.self, decoder: JSONDecoder())
            .map { dto in
                return dto.projectID
            }
    }
    
    // MARK: - Bookmark
    func bookmark(projectID: Int) -> Observable<Int> {
        let projectIDDTO = ProjectIDDTO(projectID: projectID)  // 북마크 할 모집글의 ID
        let bookmarkEndpoint = ProjectEndpoint.bookmark(requestDTO: projectIDDTO)
        
        return networkService.request(to: bookmarkEndpoint, interceptor: AuthInterceptor())
            .map { _ in projectID }
    }
    
    // MARK: - Delete
    func delete(projectID: Int) -> Observable<Int> {
        let userIDDTO = UserIDDTO(userID: Int(tokenStorage.get(.userID)) ?? 0)
        let deleteEndpoint = ProjectEndpoint.delete(requestDTO: userIDDTO, projectID: String(projectID))
        
        return networkService.request(to: deleteEndpoint, interceptor: nil)
            .map { _ in projectID }
    }
    
    // MARK: - CancelApplication
    func cancel(projectID: Int) -> Observable<Int> {
        .just(projectID)
    }
    
    // MARK: - Accept
    func accept(projectID: Int, applicantID: Int) -> Observable<Int> {
        .just(applicantID)
    }
    
    // MARK: - Reject
    func reject(projectID: Int, applicantID: Int) -> Observable<Int> {
        .just(applicantID)
    }
    
    // MARK: - Apply
    func apply(projectID: Int) -> Observable<Void> {
        let userID = tokenStorage.get(.userID)
        let applyEndpoint = ProjectEndpoint.apply(userID: userID, projectID: String(projectID))
        
        return networkService.request(to: applyEndpoint, interceptor: nil)
            .map { _ in }
    }
    
    // MARK: - Close
    func close(projectID: Int) -> Observable<Void> {
        let projectIDDTO = ProjectIDDTO(projectID: projectID)  // 마감 할 모집글의 ID
        let closeEndpoint = ProjectEndpoint.close(requestDTO: projectIDDTO)
        
        return networkService.request(to: closeEndpoint, interceptor: nil)
            .map { _ in }
    }
}

private extension DefaultProjectRepository {
    func convertToDTO(from project: Project) -> CreateProjectRequestDTO {
        let userID = Int(tokenStorage.get(.userID)) ?? 0
        
        let memberRequirementsDTO = project.memberRequirements.map { requirement -> MemberRequirementDTO in
            MemberRequirementDTO(
                field: requirement.field,
                recruitNumber: requirement.recruitNumber,
                requiredSkills: requirement.requiredSkills,
                requirementText: requirement.requirementText
            )
        }
        
        return CreateProjectRequestDTO(
            title: project.title,
            description: project.description,
            deadline: project.deadline.toString(format: "yyyy-MM-dd'T'HH:mm:ss"),
            startDate: project.startDate?.toString(format: "yyyy-MM-dd'T'HH:mm:ss"),
            endDate: project.endDate?.toString(format: "yyyy-MM-dd'T'HH:mm:ss"),
            memberRequirements: memberRequirementsDTO,
            applicantRestrictions: project.applicantRestrictions,
            progressMethod: project.progressMethod,
            progressStep: project.progressStep,
            userID: userID
        )
    }
}
