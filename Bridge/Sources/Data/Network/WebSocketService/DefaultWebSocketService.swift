//
//  DefaultWebSocketService.swift
//  Bridge
//
//  Created by 정호윤 on 10/18/23.
//

import Starscream

final class DefaultWebSocketService: WebSocketService {

    private var socket: WebSocket?
    private var stompConnectFrame: String?
    
    func connect(endpoint: Endpoint, stompEndpoint: StompEndpoint) {
        guard let request = endpoint.toURLRequest() else { return }
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
        
        stompConnectFrame = stompEndpoint.toFrame()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    func subscribe(_ endpoint: StompEndpoint) {
        let frame = endpoint.toFrame()
        socket?.write(string: frame)
    }
    
    func send(_ endpoint: StompEndpoint) {
        let frame = endpoint.toFrame()
        socket?.write(string: frame)
    }
}

// 메시지 data로 오면 data를 리턴해주면 되고, string이면 data로 바꿔서 리턴??
extension DefaultWebSocketService: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .viabilityChanged:
            print("[Viability Changed]\n")
            
        case .connected:
            print("[WebSocket Connected]\n")
            socket?.write(string: stompConnectFrame ?? "")
            
        case .disconnected(let reason, let code):
            print("[Websocket Disconnected]")
            print("\(reason) with code \(code)\n")
            
        case .text(let text):
            print("[Received String]")
            print(text + "\n")
            
        case .binary(let data):
            print("[Received Binary Data]")
            print("\(data)\n")
            
        case .ping:
            print("[Received Ping]")
            
        case .pong:
            print("[Received Pong]")
            
        case .reconnectSuggested:
            print("[Reconnect Suggested]")
            
        case .peerClosed:
            print("[Peer Closed]")
            
        case .cancelled:
            print("[WebSocket Canclled]")
            
        case .error(let error):
            print("[WebSocket Error]")
            print(error ?? "unknown error")
        }
    }
}
