//
//  AlertRepository.swift
//  Bridge
//
//  Created by 정호윤 on 12/22/23.
//

import RxSwift

protocol AlertRepository {
    func fetchAlerts() -> Observable<[BridgeAlert]>
    func removeAlert(id: String) -> Observable<String>
    func removeAllAlerts() -> Observable<Void>
}
