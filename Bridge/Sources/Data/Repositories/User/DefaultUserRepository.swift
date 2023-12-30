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
