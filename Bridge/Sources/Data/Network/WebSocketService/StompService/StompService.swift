//
//  StompService.swift
//  Bridge
//
//  Created by 정호윤 on 11/17/23.
//

import Foundation
import RxSwift

protocol StompService {
    func connect(_ stompEndpoint: StompEndpoint)
    func disconnect(_ stompEndpoint: StompEndpoint)
    
    func subscribe(_ stompEndpoint: StompEndpoint) -> Observable<Data>
    func unsubscribe(_ stompEndpoint: StompEndpoint)
    
    func send(_ endpoint: StompEndpoint) -> Observable<Data>
}
