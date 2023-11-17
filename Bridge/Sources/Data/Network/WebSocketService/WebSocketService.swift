//
//  WebSocketService.swift
//  Bridge
//
//  Created by 정호윤 on 10/18/23.
//

import Foundation
import RxSwift
import Starscream

final class WebSocketService {
    // MARK: - Property
    static let shared = WebSocketService()
    private init() { }
    
    private var socket: WebSocket?
    private let incomingMessage = PublishSubject<Data>()
    
    // MARK: - WebSocket method
    func connect(endpoint: Endpoint) {
        guard let request = endpoint.toURLRequest() else { return }
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    // MARK: - STOMP method
    func subscribe(_ connectEndpoint: StompEndpoint, _ subscribeEndpoint: StompEndpoint) -> Observable<Data> {
        let connectFrame = connectEndpoint.toFrame()
        let subscribeFrame = subscribeEndpoint.toFrame()
        
        socket?.write(string: connectFrame) { [weak self] in
            self?.socket?.write(string: subscribeFrame)
        }
        
        return incomingMessage
    }
    
    func unsubscribe(_ endpoint: StompEndpoint) {
        let frame = endpoint.toFrame()
        socket?.write(string: frame)
    }
    
    func send(_ endpoint: StompEndpoint) {
        let frame = endpoint.toFrame()
        socket?.write(string: frame)
    }
}

extension WebSocketService: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected:
            print("WebSocket connected")
            
        case .disconnected(let reason, let code):
            print("Websocket disconnected")
            print("\(reason) with code \(code)")
            
        case .text(let string):
            print("Received string")
            print(string)
            // stomp send인지 확인하는 로직 필요할듯
            if let jsonString = string.extractJsonString(),
               let data = jsonString.data(using: .utf8) {
                incomingMessage.onNext(data)
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
