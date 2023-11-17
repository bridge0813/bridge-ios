//
//  DefaultWebSocketService.swift
//  Bridge
//
//  Created by 정호윤 on 10/18/23.
//

import Foundation
import Starscream

final class DefaultWebSocketService: WebSocketService {
    
    static let shared = DefaultWebSocketService()
    private init() { }
    
    weak var delegate: WebSocketServiceDelegate?
    private var socket: WebSocket?
    
    func connect(_ endpoint: Endpoint) {
        guard let request = endpoint.toURLRequest() else { return }
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    func write(_ frame: String, completion: (() -> Void)? = nil) {
        socket?.write(string: frame, completion: completion)
    }
}

extension DefaultWebSocketService: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected:
            print("WebSocket connected")
            delegate?.webSocketDidConnect()
            
        case .disconnected(let reason, let code):
            print("Websocket disconnected")
            print("\(reason) with code \(code)")
            delegate?.webSocketDidDisconnect()
            
        case .text(let string):
            print("Received string")
            print(string)
            // stomp send인지 확인하는 로직 필요할듯
            if let jsonString = string.extractJsonString(),
               let data = jsonString.data(using: .utf8) {
                delegate?.webSocketDidReceive(text: data)
            }
            
        case .binary(let data):
            print("Received binary data")
            print("\(data)")
            
        case .reconnectSuggested:
            print("Reconnect suggested")
            
        case .peerClosed:
            print("Peer closed")
            
        case .cancelled:
            print("WebSocket canclled")
            
        case .error(let error):
            print("WebSocket error: ", String(describing: error))
            
        default:
            print("WebSocket did receive something")
        }
    }
}
