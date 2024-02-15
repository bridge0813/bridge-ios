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
    
    // 모든 모집글 조회
    func fetchAllProjects() -> Observable<[ProjectPreview]> {
        let userID = tokenStorage.get(.userID)
        let fetchAllProjectsEndpoint = ProjectEndpoint.fetchAllProjects(userID: userID)
        
        return networkService.request(to: fetchAllProjectsEndpoint, interceptor: nil)
            .decode(type: [ProjectPreviewResponseDTO].self, decoder: JSONDecoder())
            .map { projectPreviewDTOs in
                projectPreviewDTOs.map { $0.toEntity() }
            }
    }
    
    // 분야에 맞는 모집글 조회
    func fetchProjectsByField(for field: String) -> Observable<[ProjectPreview]> {
        let fieldRequestDTO = FieldRequestDTO(field: field.convertToUpperCaseFormat())
        let fetchProjectsEndPoint = ProjectEndpoint.fetchProjectsByField(requestDTO: fieldRequestDTO)
        
        return networkService.request(to: fetchProjectsEndPoint, interceptor: AuthInterceptor())
            .decode(type: [ProjectPreviewResponseDTO].self, decoder: JSONDecoder())
            .map { projectPreviewDTOs in
                projectPreviewDTOs.map { $0.toEntity() }
            }
    }
    
    // 인기 모집글 조회
    func fetchHotProjects() -> Observable<[ProjectPreview]> {
        let userID = tokenStorage.get(.userID)
        let fetchHotProjectsEndpoint = ProjectEndpoint.fetchHotProjects(userID: userID)
        
        return networkService.request(to: fetchHotProjectsEndpoint, interceptor: nil)
            .decode(type: [HotProjectResponseDTO].self, decoder: JSONDecoder())
            .map { hotProjectDTOs in
                hotProjectDTOs.map { $0.toEntity() }
            }
    }
    
    // 마감임박 모집글 조회
    func fetchDeadlineProjects() -> Observable<[ProjectPreview]> {
        let userID = tokenStorage.get(.userID)
        let fetchDeadlineProjectsEndpoint = ProjectEndpoint.fetchDeadlineProjects(userID: userID)
        
        return networkService.request(to: fetchDeadlineProjectsEndpoint, interceptor: nil)
            .decode(type: [DeadlineProjectResponseDTO].self, decoder: JSONDecoder())
            .map { deadlineProjectDTOs in
                deadlineProjectDTOs.map { $0.toEntity() }
            }
    }
    
    // 내가 지원한 모집글 조회
    func fetchAppliedProjects() -> Observable<[ProjectPreview]> {
        return networkService.request(to: ProjectEndpoint.fetchAppliedProjects, interceptor: AuthInterceptor())
            .decode(type: [AppliedProjectResponseDTO].self, decoder: JSONDecoder())
            .map { appliedProjectDTOs in
                let appliedProjectList = Set(appliedProjectDTOs.map { $0.toEntity() })  // 중복 요소 제거
                return Array(appliedProjectList)
            }
    }
    
    // 내가 작성한 모집글 조회
    func fetchMyProjects() -> Observable<[ProjectPreview]> {
        return networkService.request(to: ProjectEndpoint.fetchMyProjects, interceptor: AuthInterceptor())
            .decode(type: [MyProjectResponseDTO].self, decoder: JSONDecoder())
            .map { myProjectDTOs in
                myProjectDTOs.map { $0.toEntity() }
            }
    }
    
    // 필터링된 모집글 조회
    func fetchFilteredProjects(filterBy fieldTechStack: FieldTechStack) -> Observable<[ProjectPreview]> {
        let filterRequestDTO = FilteredProjectRequestDTO(
            field: fieldTechStack.field.convertToUpperCaseFormat(),
            techStacks: fieldTechStack.techStacks.map { stack in
                // 서버측 워딩에 맞게 수정. 대문자 처리 및 띄어쓰기 제거
                if stack == "C++" { return "CPP" }
                else { return stack.uppercased().replacingOccurrences(of: " ", with: "") }
            }
        )
        
        let filterEndpoint = ProjectEndpoint.fetchFilteredProjects(requestDTO: filterRequestDTO)
        
        return networkService.request(to: filterEndpoint, interceptor: nil)
            .decode(type: [ProjectPreviewResponseDTO].self, decoder: JSONDecoder())
            .map { projectPreviewDTOs in
                projectPreviewDTOs.map { $0.toEntity() }
            }
    }
    
    // 모집글 상세 조회
    func fetchProjectDetail(with projectID: Int) -> Observable<Project> {
        let userID = tokenStorage.get(.userID)
        let fetchProjectDetailEndpoint = ProjectEndpoint.fetchProjectDetail(
            userID: userID,
            projectID: String(projectID)
        )
        
        return networkService.request(to: fetchProjectDetailEndpoint, interceptor: nil)
            .decode(type: ProjectDetailDTO.self, decoder: JSONDecoder())
            .map { dto in
                var project = dto.toEntity()
                project.id = projectID
                return project
            }
    }
    
    // 모집글 생성
    func create(project: Project) -> Observable<Int> {
        let createProjectDTO = convertToCreateProjectDTO(from: project)
        let createProjectEndpoint = ProjectEndpoint.create(requestDTO: createProjectDTO)
        
        return networkService.request(to: createProjectEndpoint, interceptor: AuthInterceptor())
            .decode(type: ProjectIDDTO.self, decoder: JSONDecoder())
            .map { dto in
                return dto.projectID
            }
    }
    
    // 모집글 수정
    func update(project: Project) -> Observable<Void> {
        let updateProjectDTO = convertToUpdateProjectDTO(from: project)
        let updateProjectEndpoint = ProjectEndpoint.update(
            requestDTO: updateProjectDTO, projectID: String(project.id)
        )
        
        return networkService.request(to: updateProjectEndpoint, interceptor: AuthInterceptor())
            .map { _ in }
    }
    
    // 모집글 제거
    func delete(projectID: Int) -> Observable<Int> {
        let userIDDTO = UserIDDTO(userID: Int(tokenStorage.get(.userID)) ?? 0)
        let deleteEndpoint = ProjectEndpoint.delete(requestDTO: userIDDTO, projectID: String(projectID))
        
        return networkService.request(to: deleteEndpoint, interceptor: AuthInterceptor())
            .map { _ in projectID }
    }
    
    // 모집글 마감
    func close(projectID: Int) -> Observable<Int> {
        let projectIDDTO = ProjectIDDTO(projectID: projectID)  // 마감 할 모집글의 ID
        let closeEndpoint = ProjectEndpoint.close(requestDTO: projectIDDTO)
        
        return networkService.request(to: closeEndpoint, interceptor: AuthInterceptor())
            .map { _ in projectID }
    }
    
    // 북마크
    func bookmark(projectID: Int) -> Observable<Int> {
        let projectIDDTO = ProjectIDDTO(projectID: projectID)  // 북마크 할 모집글의 ID
        let bookmarkEndpoint = ProjectEndpoint.bookmark(requestDTO: projectIDDTO)
        
        return networkService.request(to: bookmarkEndpoint, interceptor: AuthInterceptor())
            .map { _ in projectID }
    }
}

// MARK: - Methods
private extension DefaultProjectRepository {
    /// '모집글 작성'의 requestDTO를 만들어주는 메서드.
    func convertToCreateProjectDTO(from project: Project) -> CreateProjectRequestDTO {
        let userID = Int(tokenStorage.get(.userID)) ?? 0
        
        let memberRequirementsDTO = project.memberRequirements.map { requirement -> MemberRequirementDTO in
            MemberRequirementDTO(
                field: requirement.field,
                recruitNumber: requirement.recruitNumber,
                requiredSkills: requirement.requiredSkills.map { skill in
                    // 서버측 워딩에 맞게 수정. 대문자 처리 및 띄어쓰기 제거
                    if skill == "C++" { return "CPP" }
                    else { return skill.uppercased().replacingOccurrences(of: " ", with: "") }
                },
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
    
    /// '모집글 수정'의 requestDTO를 만들어주는 메서드.
    func convertToUpdateProjectDTO(from project: Project) -> UpdateProjectRequestDTO {
        let memberRequirementsDTO = project.memberRequirements.map { requirement -> MemberRequirementDTO in
            MemberRequirementDTO(
                field: requirement.field,
                recruitNumber: requirement.recruitNumber,
                requiredSkills: requirement.requiredSkills.map { skill in
                    // 서버측 워딩에 맞게 수정. 대문자 처리 및 띄어쓰기 제거
                    if skill == "C++" { return "CPP" }
                    if skill == "Objective-c" { return "OBJECTIVE_C" }
                    
                    return skill.uppercased().replacingOccurrences(of: " ", with: "")
                },
                requirementText: requirement.requirementText
            )
        }
        
        return UpdateProjectRequestDTO(
            title: project.title,
            description: project.description,
            deadline: project.deadline.toString(format: "yyyy-MM-dd'T'HH:mm:ss"),
            startDate: project.startDate?.toString(format: "yyyy-MM-dd'T'HH:mm:ss"),
            endDate: project.endDate?.toString(format: "yyyy-MM-dd'T'HH:mm:ss"),
            memberRequirements: memberRequirementsDTO,
            applicantRestrictions: project.applicantRestrictions,
            progressMethod: project.progressMethod,
            progressStep: project.progressStep
        )
    }
}
