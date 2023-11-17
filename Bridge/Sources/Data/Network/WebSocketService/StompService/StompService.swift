//
//  StompService.swift
//  Bridge
//
//  Created by 정호윤 on 11/17/23.
//

import Foundation
import RxSwift

protocol StompService {
    func subscribe(_ connectEndpoint: StompEndpoint, _ subscribeEndpoint: StompEndpoint) -> Observable<Data>
    func unsubscribe(_ endpoint: StompEndpoint)
    
    func send(_ endpoint: StompEndpoint)
}
