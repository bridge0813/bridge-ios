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
    private let updatedData = PublishSubject<Data>()
    private let incomingData = PublishSubject<Data>()
    
    // MARK: - Init
    init(webSocketService: WebSocketService) {
        self.webSocketService = webSocketService
        webSocketService.delegate = self
    }
    
    // MARK: - Method
    func connect(_ stompEndpoint: StompEndpoint) {
        let connectFrame = stompEndpoint.toFrame()
        webSocketService.write(connectFrame) {
            NotificationCenter.default.post(name: .stompDidConnectedNotification, object: nil)
        }
    }
    
    func disconnect(_ stompEndpoint: StompEndpoint) {
        let disconnectFrame = stompEndpoint.toFrame()
        webSocketService.write(disconnectFrame, completion: nil)
    }
    
    func subscribe(_ stompEndpoint: StompEndpoint) -> Observable<Data> {
        let subscribeFrame = stompEndpoint.toFrame()
        webSocketService.write(subscribeFrame, completion: nil)
        return updatedData
    }
    
    func observe() -> Observable<Data> {
        incomingData
    }
    
    func unsubscribe(_ stompEndpoint: StompEndpoint) {
        let unsubscribeFrame = stompEndpoint.toFrame()
        webSocketService.write(unsubscribeFrame, completion: nil)
    }
    
    func send(_ endpoint: StompEndpoint) {
        let frame = endpoint.toFrame()
        webSocketService.write(frame, completion: nil)
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
              command == StompResponseCommand.message.rawValue,
              let jsonString = text.extractJsonString(),
              let data = jsonString.data(using: .utf8)
        else { return }
           
        if jsonString.contains("\"chatHistory\":null") {
            incomingData.onNext(data)
        } else {
            updatedData.onNext(data)
        }
    }
    
    func webSocketDidReceive(data: Data) { }
}
