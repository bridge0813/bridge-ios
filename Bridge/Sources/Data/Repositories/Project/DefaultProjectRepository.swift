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
    
    // MARK: - List
    func fetchAllProjects() -> Observable<[ProjectPreview]> {
        return networkService.request(ProjectEndpoint.fetchAllProjects, interceptor: nil)
            .decode(type: [ProjectPreviewDTO].self, decoder: JSONDecoder())
            .map { projectPreviewDTOs in
                projectPreviewDTOs.map { $0.toEntity() }
            }
    }
    
    func fetchProjectsByField(for field: String) -> Observable<[ProjectPreview]> {
        let fieldRequestDTO = FieldRequestDTO(field: field)
        let fetchProjectsEndPoint = ProjectEndpoint.fetchProjectsByField(requestDTO: fieldRequestDTO)
        
        return networkService.request(fetchProjectsEndPoint, interceptor: nil)
            .decode(type: [ProjectPreviewDTO].self, decoder: JSONDecoder())
            .map { projectPreviewDTOs in
                projectPreviewDTOs.map { $0.toEntity() }
            }
    }
    
    func fetchHotProjects() -> Observable<[ProjectPreview]> {
        return networkService.request(ProjectEndpoint.fetchHotProjects, interceptor: nil)
            .decode(type: [HotProjectResponseDTO].self, decoder: JSONDecoder())
            .map { hotProjectDTOs in
                hotProjectDTOs.map { $0.toEntity() }
            }
    }
    
    // MARK: - Detail
    func fetchProjectDetail(with projectID: Int) -> Observable<Project> {
        .just(ProjectDetailDTO.projectDetailTest.toEntity())
    }
    
    
    // MARK: - Create
    func create(with project: Project) -> Observable<Int> {
        let createProjectDTO = convertToDTO(from: project)
        let createProjectEndpoint = ProjectEndpoint.create(requestDTO: createProjectDTO)
        
        return networkService.request(createProjectEndpoint, interceptor: nil)
            .decode(type: CreateProjectResponseDTO.self, decoder: JSONDecoder())
            .map { dto in
                return dto.projectId
            }
    }
}

private extension DefaultProjectRepository {
    func convertToDTO(from project: Project) -> CreateProjectRequestDTO {
        let userID = Int(tokenStorage.get(.userID) ?? invalidToken) ?? 0
        
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
            userId: userID
        )
    }
}
