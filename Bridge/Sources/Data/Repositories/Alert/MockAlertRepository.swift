//
//  MockAlertRepository.swift
//  Bridge
//
//  Created by 정호윤 on 12/22/23.
//

import RxSwift

final class MockAlertRepository: AlertRepository {
    func fetchAlerts() -> Observable<[BridgeAlert]> {
        .just(BridgeAlertResponseDTO.testAlerts.map { $0.toEntity() })
    }
    
    func removeAlert(id: String) -> Observable<Void> {
        .just(())
    }
    
    func removeAllAlerts() -> Observable<Void> {
        .just(())
    }
}
