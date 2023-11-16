//
//  WebSocketService.swift
//  Bridge
//
//  Created by 정호윤 on 10/18/23.
//

protocol WebSocketService {
    func connect(endpoint: Endpoint, stompEndpoint: StompEndpoint)
    func disconnect()
    
    func subscribe(_ endpoint: StompEndpoint)
    func send(_ endpoint: StompEndpoint)
}
