//
//  DefaultStompService.swift
//  Bridge
//
//  Created by 정호윤 on 11/17/23.
//

import Foundation
import RxSwift

final class DefaultStompService: StompService {
    // MARK: - Property
    private let webSocketService: WebSocketService
    private let updatedMessages = PublishSubject<Data>()
    private let incomingMessage = PublishSubject<Data>()
    
    // MARK: - Init
    init(webSocketService: WebSocketService) {
        self.webSocketService = webSocketService
        webSocketService.delegate = self
    }
    
    // MARK: - Method
    func connect(_ stompEndpoint: StompEndpoint) {
        let connectFrame = stompEndpoint.toFrame()
        webSocketService.write(connectFrame)
    }
    
    func disconnect(_ stompEndpoint: StompEndpoint) {
        let disconnectFrame = stompEndpoint.toFrame()
        webSocketService.write(disconnectFrame)
    }
    
    func subscribe(_ stompEndpoint: StompEndpoint) -> Observable<Data> {
        let subscribeFrame = stompEndpoint.toFrame()
        webSocketService.write(subscribeFrame)
        return updatedMessages
    }
    
    func observe() -> Observable<Data> {
        incomingMessage
    }
    
    func unsubscribe(_ stompEndpoint: StompEndpoint) {
        let unsubscribeFrame = stompEndpoint.toFrame()
        webSocketService.write(unsubscribeFrame)
    }
    
    func send(_ endpoint: StompEndpoint) {
        let frame = endpoint.toFrame()
        webSocketService.write(frame)
    }
}

// MARK: - WebSocket delegate
extension DefaultStompService: WebSocketServiceDelegate {
    func webSocketDidConnect() {
        connect(MessageStompEndpoint.connect)
    }
    
    func webSocketDidDisconnect() {
        disconnect(MessageStompEndpoint.disconnect)
    }
    
    func webSocketDidReceive(text: String) {
        guard let command = text.extractCommand(.message),
              command == StompResponseCommand.message.rawValue
        else { return }
        
        if let jsonArrayString = text.extractJsonArrayString(), let data = jsonArrayString.data(using: .utf8) {
            updatedMessages.onNext(data)
        } else if let jsonString = text.extractJsonString(), let data = jsonString.data(using: .utf8) {
            incomingMessage.onNext(data)
        }
    }
    
    func webSocketDidReceive(data: Data) { }
}
