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
    
    func createProject(with project: CreateProject) -> Observable<Int> {
        let createProjectDTO = toCreateProjectDTO(from: project)
        let createProjectEndpoint = ProjectEndpoint.create(requestDTO: createProjectDTO)
        
        return networkService.request(createProjectEndpoint, interceptor: AuthInterceptor())
            .decode(type: CreateProjectResponseDTO.self, decoder: JSONDecoder())
            .map { dto in
                return dto.projectId
            }
    }
}

private extension DefaultProjectRepository {
    func toCreateProjectDTO(from project: CreateProject) -> CreateProjectDTO {
        let userID = Int(tokenStorage.get(.userID) ?? invalidToken)
        
        let memberRequirementsDTO = project.memberRequirements.map { requirement -> MemberRequirementDTO in
            MemberRequirementDTO(
                field: requirement.field,
                recruitNumber: requirement.recruitNumber,
                requiredSkills: requirement.requiredSkills,
                requirementText: requirement.requirementText
            )
        }
        
        return CreateProjectDTO(
            title: project.title,
            description: project.description,
            deadline: project.deadline,
            startDate: project.startDate,
            endDate: project.endDate,
            memberRequirements: memberRequirementsDTO,
            applicantRestrictions: project.applicantRestrictions,
            progressMethod: project.progressMethod,
            progressStep: project.progressStep,
            userId: userID
        )
    }
}
