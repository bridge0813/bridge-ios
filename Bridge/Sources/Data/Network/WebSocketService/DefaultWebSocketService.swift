//
//  DefaultWebSocketService.swift
//  Bridge
//
//  Created by 정호윤 on 10/18/23.
//

import Foundation
import Starscream

// TODO: 방식 자체 고민해보기...
final class DefaultWebSocketService: WebSocketService {
    
    private var socket: WebSocket?
    
    func connect(_ endpoint: WebSocketEndpoint) {
        guard let request = endpoint.toURLRequest() else { return }
        
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    func write() {
        
    }
}

extension DefaultWebSocketService: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .viabilityChanged:
            print("viabilityChanged")
            
        case .connected(let headers):
            client.write(string: "정호윤")
            print("websocket connected: \(headers)")
            
        case .disconnected(let reason, let code):
            print("websocket disconnected: \(reason) with code: \(code)")
            
        case .text(let text):
            print("Received string: \(text)")
            
        case .binary(let data):
            print("Received binary data: \(data.count)")
            
        case .ping, .pong:
            break
            
        case .reconnectSuggested:
            print("reconnectSuggested")
            
        case .peerClosed:
            print("peer closed")
            
        case .cancelled:
            print("websocket canclled")
            
        case .error(let error):
            print("websocket error: \(String(describing: error))")
        }
    }
}
