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
        .just(ApplicantProfileResponseDTO.testArray.compactMap { $0.toEntity() })
    }
    
    // MARK: - Accept
    func accept(projectID: Int, applicantID: Int) -> Observable<Int> {
        .just(applicantID)
    }
    
    // MARK: - Reject
    func reject(projectID: Int, applicantID: Int) -> Observable<Int> {
        .just(applicantID)
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
