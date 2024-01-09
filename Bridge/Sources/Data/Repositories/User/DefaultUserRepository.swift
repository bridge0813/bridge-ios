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
    
    /// 프로필 조회
    func fetchProfile() -> Observable<Profile> {
        return .just(ProfileResponseDTO.testData.toEntity()) 
    }
    
    /// 프로필 간략형 조회(마이페이지)
    func fetchProfilePreview() -> Observable<ProfilePreview> {
        let userID = tokenStorage.get(.userID) 
        let userEndpoint = UserEndpoint.fetchProfilePreview(userID: userID)
        
        return networkService.request(to: userEndpoint, interceptor: AuthInterceptor())
            .decode(type: ProfilePreviewResponseDTO.self, decoder: JSONDecoder())
            .map { $0.toEntity() }
    }
    
    /// 프로필 수정
    func updateProfile(_ profile: Profile) -> Observable<Void> {
        let userID = tokenStorage.get(.userID)
        return .just(())
    }
    
    /// 관심분야 수정
    func changeField(selectedFields: [String]) -> Observable<Void> {
        let userID = tokenStorage.get(.userID)
        let userEndpoint = UserEndpoint.changeField(
            requestDTO: ChangeFieldRequestDTO(userID: Int(userID) ?? -1, selectedFields: selectedFields)
        )
        
        return networkService.request(to: userEndpoint, interceptor: nil)
            .map { _ in }
    }
    
    /// 북마크 모집글 조회
    func fetchBookmarkedProjects() -> Observable<[BookmarkedProject]> {
        let userID = tokenStorage.get(.userID)
        let userEndpoint = UserEndpoint.fetchBookmarkedProjects(userID: userID)
        
        return networkService.request(to: userEndpoint, interceptor: nil)
            .decode(type: [BookmarkedProjectResponseDTO].self, decoder: JSONDecoder())
            .map { dtos in
                dtos.map { $0.toEntity() }
            }
    }
}

extension DefaultUserRepository {
    /// 프로필 -> 프로필 수정 DTO 전환 메서드
    private func convertToUpdateProfileDTO(from profile: Profile) -> UpdateProfileRequestDTO {
        // 분야 및 스택 DTO
        let fieldTechStacksDTO = profile.fieldTechStacks.map { fieldTechStack -> FieldTechStackDTO in
            FieldTechStackDTO(
                field: convertFieldName(field: fieldTechStack.field),
                techStacks: fieldTechStack.techStacks.map { stack in
                    // 서버측 워딩에 맞게 수정. 대문자 처리 및 띄어쓰기 제거
                    if stack == "C++" { return "CPP" }
                    else { return stack.uppercased().replacingOccurrences(of: " ", with: "") }
                }
            )
        }
        
        return UpdateProfileRequestDTO(
            imageData: profile.updatedImage?.jpegData(compressionQuality: 1),
            name: profile.name,
            introduction: profile.introduction,
            fieldTechStacks: fieldTechStacksDTO,
            carrer: profile.carrer,
            links: profile.links,
            files: profile.files.map { $0.fileData ?? Data() }
        )
    }
    
    private func convertFieldName(field: String) -> String {
        switch field {
        case "iOS": return "IOS"
        case "안드로이드": return "ANDROID"
        case "프론트엔드": return "FRONTEND"
        case "백엔드": return "BACKEND"
        case "UI/UX": return "UIUX"
        case "BI/BX": return "BIBX"
        case "영상/모션": return "VIDEOMOTION"
        case "PM": return "PM"
        default: return "Error"
        }
    }
}
