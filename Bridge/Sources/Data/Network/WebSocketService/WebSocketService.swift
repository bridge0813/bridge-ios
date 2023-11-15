//
//  WebSocketService.swift
//  Bridge
//
//  Created by 정호윤 on 10/18/23.
//

import Foundation

protocol WebSocketService {
    func connect(_ endpoint: Endpoint)
    func disconnect()
}
