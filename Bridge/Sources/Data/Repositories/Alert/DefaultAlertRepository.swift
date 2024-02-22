//
//  DefaultAlertRepository.swift
//  Bridge
//
//  Created by 정호윤 on 12/22/23.
//

import Foundation
import RxSwift

final class DefaultAlertRepository: AlertRepository {

    private let networkService: NetworkService
    private let tokenStorage: TokenStorage
    
    init(networkService: NetworkService, tokenStorage: TokenStorage = KeychainTokenStorage()) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
    
    func fetchAlerts() -> Observable<[BridgeAlert]> {
        let alertEndpoint = AlertEndpoint.fetchAlerts
        
        return networkService.request(to: alertEndpoint, interceptor: AuthInterceptor())
            .decode(type: [BridgeAlertResponseDTO].self, decoder: JSONDecoder())
            .map { alertDTOs in
                alertDTOs.map { $0.toEntity() }
            }
    }
    
    func removeAlert(id: String) -> Observable<String> {
        let alertEndpoint = AlertEndpoint.removeAlert(id: id)
        
        return networkService.request(to: alertEndpoint, interceptor: AuthInterceptor())
            .map { _ in id }
    }
    
    func removeAllAlerts() -> Observable<Void> {
        let alertEndpoint = AlertEndpoint.removeAllAlerts
        
        return networkService.request(to: alertEndpoint, interceptor: AuthInterceptor())
            .map { _ in }
    }
}
