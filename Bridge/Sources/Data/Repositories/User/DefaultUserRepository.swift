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
    
    func fetchProfilePreview() -> Observable<ProfilePreview> {
        let userID = tokenStorage.get(.userID) 
        let userEndpoint = UserEndpoint.fetchProfilePreview(userID: userID)
        
        return networkService.request(to: userEndpoint, interceptor: AuthInterceptor())
            .decode(type: ProfilePreviewResponseDTO.self, decoder: JSONDecoder())
            .map { $0.toEntity() }
    }
    
    func fetchApplicantList(projectID: Int) -> Observable<[ApplicantProfile]> {
        .just(ApplicantProfileResponseDTO.testArray.compactMap { $0.toEntity() })
    }
    
    func changeField(selectedFields: [String]) -> Observable<Void> {
        let userID = tokenStorage.get(.userID)
        let userEndpoint = UserEndpoint.changeField(
            requestDTO: ChangeFieldRequestDTO(userID: Int(userID) ?? -1, selectedFields: selectedFields)
        )
        
        return networkService.request(to: userEndpoint, interceptor: nil)
            .map { _ in }
    }
}
