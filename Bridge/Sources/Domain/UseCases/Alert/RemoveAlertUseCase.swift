//
//  RemoveAlertUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 12/22/23.
//

import RxSwift

protocol RemoveAlertUseCase {
    func remove(id: String) -> Observable<String>
    func removeAll() -> Observable<Void>
}

final class DefaultRemoveAlertUseCase: RemoveAlertUseCase {
    
    private let alertRepository: AlertRepository
    
    init(alertRepository: AlertRepository) {
        self.alertRepository = alertRepository
    }
    
    func remove(id: String) -> Observable<String> {
        alertRepository.removeAlert(id: id)
    }
    
    func removeAll() -> Observable<Void> {
        alertRepository.removeAllAlerts()
    }
}
