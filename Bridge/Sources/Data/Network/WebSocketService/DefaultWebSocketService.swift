//
//  DefaultWebSocketService.swift
//  Bridge
//
//  Created by 정호윤 on 10/18/23.
//

import Starscream

final class DefaultWebSocketService: WebSocketService {
    
    static let shared = DefaultWebSocketService()
    private init() { }
    
    weak var delegate: WebSocketServiceDelegate?
    private var socket: WebSocket?
    
    func connect(to endpoint: Endpoint) {
        guard let request = endpoint.toURLRequest() else { return }
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    func write(_ frame: WebSocketFrame, completion: (() -> Void)?) {
        socket?.write(string: frame, completion: completion)
    }
}

extension DefaultWebSocketService: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .viabilityChanged:
            print("[Websocket] Viability changed")
            
        case .connected:
            print("[WebSocket] Connected")
            delegate?.webSocketDidConnect()
            
        case .disconnected(let reason, let code):
            print("[Websocket] Disconnected")
            print("\(reason) with code \(code)")
            delegate?.webSocketDidDisconnect()
            
        case .text(let text):
            print("[Websocket] Received string")
            print(text)
            delegate?.webSocketDidReceive(text: text)
            
        case .binary(let data):
            print("[Websocket] Received binary data")
            print("\(data)")
            delegate?.webSocketDidReceive(data: data)
            
        case .reconnectSuggested:
            print("[Websocket] Reconnect suggested")
            
        case .peerClosed:
            print("[Websocket] Peer closed")
            
        case .cancelled:
            print("[WebSocket] Cancelled")
            
        case .error(let error):
            print("[WebSocket] Error")
            print(String(describing: error))
            
        default:
            print("[WebSocket] Did receive something")
        }
    }
}
