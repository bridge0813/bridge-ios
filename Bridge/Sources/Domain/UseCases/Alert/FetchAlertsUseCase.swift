//
//  FetchAlertsUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 12/22/23.
//

import RxSwift

protocol FetchAlertsUseCase {
    func fetch() -> Observable<[BridgeAlert]>
}

final class DefaultFetchAlertsUseCase: FetchAlertsUseCase {
    
    private let alertRepository: AlertRepository
    
    init(alertRepository: AlertRepository) {
        self.alertRepository = alertRepository
    }
    
    func fetch() -> Observable<[BridgeAlert]> {
        alertRepository.fetchAlerts()
    }
}
