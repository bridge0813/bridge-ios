//
//  DefaultUserRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/25.
//  Edited by 정호윤 on 2023/12/12.

import Foundation
import RxSwift

final class DefaultUserRepository: UserRepository {
    
    private let networkService: NetworkService
    private let tokenStorage: TokenStorage
    
    init(networkService: NetworkService, tokenStorage: TokenStorage = KeychainTokenStorage()) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
    
    // 프로필 조회
    func fetchProfile(otherUserID: String?) -> Observable<Profile> {
        // otherUserID가 있을 경우, 다른 유저의 프로필을 조회
        // 없을 경우, 내 프로필 조회
        let userID = otherUserID ?? tokenStorage.get(.userID)
        let userEndpoint = UserEndpoint.fetchProfile(userID: userID)
        
        return networkService.request(to: userEndpoint, interceptor: nil)
            .decode(type: ProfileResponseDTO.self, decoder: JSONDecoder())
            .map { $0.toEntity() }
    }
    
    // 마이 페이지 정보 조회(프로필의 약식정보)
    func fetchProfilePreview() -> Observable<ProfilePreview> {
        let userID = tokenStorage.get(.userID) 
        let userEndpoint = UserEndpoint.fetchProfilePreview(userID: userID)
        
        return networkService.request(to: userEndpoint, interceptor: AuthInterceptor())
            .decode(type: ProfilePreviewResponseDTO.self, decoder: JSONDecoder())
            .map { $0.toEntity() }
    }
    
    // 프로필 생성
    func createProfile(_ profile: Profile) -> Observable<Void> {
        let userID = tokenStorage.get(.userID)
        let userEndpoint = UserEndpoint.createProfile(
            multipartData: createProfileMultipartData(profile: profile),
            userID: userID,
            boundaryName: "Boundary-\(UUID().uuidString)"
        )
        
        return networkService.request(to: userEndpoint, interceptor: AuthInterceptor())
            .map { _ in }
    }
    
    // 프로필 수정
    func updateProfile(_ profile: Profile) -> Observable<Void> {
        let userID = tokenStorage.get(.userID)
        let userEndpoint = UserEndpoint.updateProfile(
            multipartData: createProfileMultipartData(profile: profile),
            userID: userID,
            boundaryName: "Boundary-\(UUID().uuidString)"
        )
        
        return networkService.request(to: userEndpoint, interceptor: AuthInterceptor())
            .map { _ in }
    }
    
    // 관심분야 수정
    func changeField(selectedFields: [String]) -> Observable<Void> {
        let userID = tokenStorage.get(.userID)
        let userEndpoint = UserEndpoint.changeField(
            requestDTO: ChangeFieldRequestDTO(userID: Int(userID) ?? -1, selectedFields: selectedFields)
        )
        
        return networkService.request(to: userEndpoint, interceptor: AuthInterceptor())
            .map { _ in }
    }
    
    // 북마크한 모집글 조회
    func fetchBookmarkedProjects() -> Observable<[BookmarkedProject]> {
        let userID = tokenStorage.get(.userID)
        let userEndpoint = UserEndpoint.fetchBookmarkedProjects(userID: userID)
        
        return networkService.request(to: userEndpoint, interceptor: AuthInterceptor())
            .decode(type: [BookmarkedProjectResponseDTO].self, decoder: JSONDecoder())
            .map { dtos in
                dtos.map { $0.toEntity() }
            }
    }
}

extension DefaultUserRepository {
    /// Multipart/form-data 바디 구성을 위한 데이터 생성(프로필 생성, 수정 모두 사용가능)
    private func createProfileMultipartData(profile: Profile) -> ProfileMultipartData {
        // 분야 및 스택 DTO
        let fieldTechStacksDTO = profile.fieldTechStacks.map { fieldTechStack -> FieldTechStackDTO in
            FieldTechStackDTO(
                field: fieldTechStack.field.convertToUpperCaseFormat(),
                techStacks: fieldTechStack.techStacks.map { stack in
                    // 서버측 워딩에 맞게 수정. 대문자 처리 및 띄어쓰기 제거
                    if stack == "C++" { return "CPP" }
                    if stack == "Objective-c" { return "OBJECTIVE_C" }
                    
                    return stack.uppercased().replacingOccurrences(of: " ", with: "")
                }
            )
        }
        
        // 식별자가 없는 파일은 기존에 존재하던 파일
        let originalFileIDs = profile.files.filter { $0.id != nil }.compactMap { $0.id }
        
        // 데이터가 있는 파일은 새롭게 추가한 파일
        let files = profile.files.filter { $0.data != nil }.map { file in
            return ReferenceFileRequestDTO(url: file.url, name: file.name, data: file.data ?? Data())
        }
        
        // 프로필 생성을 위한 DTO
        let createProfileDTO = CreateProfileRequestDTO(
            name: profile.name,
            introduction: profile.introduction,
            career: profile.career,
            fieldTechStacks: fieldTechStacksDTO,
            links: profile.links
        )
        
        // 프로필 수정을 위한 DTO
        let updateProfileDTO = UpdateProfileRequestDTO(
            name: profile.name,
            introduction: profile.introduction,
            career: profile.career,
            fieldTechStacks: fieldTechStacksDTO,
            links: profile.links, 
            originalFileIDs: originalFileIDs
        )
 
        return ProfileMultipartData(
            createProfile: createProfileDTO, 
            updateProfile: updateProfileDTO,
            imageData: profile.updatedImage?.jpegData(compressionQuality: 1),
            files: files
        )
    }
}
