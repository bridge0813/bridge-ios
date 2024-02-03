//
//  DefaultApplicantRepository.swift
//  Bridge
//
//  Created by 엄지호 on 12/23/23.
//

import Foundation
import RxSwift

final class DefaultApplicantRepository: ApplicantRepository {
    
    private let networkService: NetworkService
    private let tokenStorage: TokenStorage
    
    init(networkService: NetworkService, tokenStorage: TokenStorage = KeychainTokenStorage()) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
    
    // MARK: - ApplicantList
    func fetchApplicantList(projectID: Int) -> Observable<[ApplicantProfile]> {
        let fetchApplicantListEndpoint = ApplicantEndpoint.fetchApplicantList(projectID: String(projectID))
        
        return networkService.request(to: fetchApplicantListEndpoint, interceptor: AuthInterceptor())
            .decode(type: [ApplicantProfileResponseDTO].self, decoder: JSONDecoder())
            .map { applicantListDTOs in
                let applicantList = Set(applicantListDTOs.map { $0.toEntity() })  // 중복요소 제거
                return Array(applicantList)
            }
    }
    
    // MARK: - Accept
    func accept(projectID: Int, applicantID: Int) -> Observable<Int> {
        let acceptEndpoint = ApplicantEndpoint.accept(
            userID: String(applicantID),
            projectID: String(projectID)
        )
        
        return networkService.request(to: acceptEndpoint, interceptor: AuthInterceptor())
            .map { _ in applicantID }
    }
    
    // MARK: - Reject
    func reject(projectID: Int, applicantID: Int) -> Observable<Int> {
        let rejectEndpoint = ApplicantEndpoint.reject(
            userID: String(applicantID),
            projectID: String(projectID)
        )
        
        return networkService.request(to: rejectEndpoint, interceptor: AuthInterceptor())
            .map { _ in applicantID }
    }
    
    // MARK: - CancelApplication
    func cancel(projectID: Int) -> Observable<Int> {
        let cancelEndpoint = ApplicantEndpoint.cancel(projectID: String(projectID))
        
        return networkService.request(to: cancelEndpoint, interceptor: AuthInterceptor())
            .map { _ in projectID }
    }
    
    // MARK: - Apply
    func apply(projectID: Int) -> Observable<Void> {
        let applyEndpoint = ApplicantEndpoint.apply(projectID: String(projectID))
        
        return networkService.request(to: applyEndpoint, interceptor: AuthInterceptor())
            .map { _ in }
    }
}
