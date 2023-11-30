//
//  DefaultProfileRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/25.
//

import Foundation
import RxSwift

final class DefaultProfileRepository: ProfileRepository {
    
    private let networkService: NetworkService
    private let tokenStorage: TokenStorage
    
    init(networkService: NetworkService, tokenStorage: TokenStorage = KeychainTokenStorage()) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
    
    func fetchProfilePreview() -> Observable<ProfilePreview> {
        let userID = tokenStorage.get(.userID) ?? invalidToken
        let profilePreviewEndpoint = ProfileEndpoint.fetchProfilePreview(userID: userID)
        
        return networkService.request(profilePreviewEndpoint, interceptor: AuthInterceptor())
            .decode(type: ProfilePreviewResponseDTO.self, decoder: JSONDecoder())
            .map { dto in
                dto.toEntity()
            }
    }
}
