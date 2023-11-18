//
//  DefaultStompService.swift
//  Bridge
//
//  Created by 정호윤 on 11/17/23.
//

import Foundation
import RxSwift

final class DefaultStompService: StompService {
    
    private let webSocketService: WebSocketService
    
    private let incomingMessage = PublishSubject<Data>()
    
    init(webSocketService: WebSocketService) {
        self.webSocketService = webSocketService
        webSocketService.delegate = self
    }
    
    func subscribe(_ connectEndpoint: StompEndpoint, _ subscribeEndpoint: StompEndpoint) -> Observable<Data> {
        let connectFrame = connectEndpoint.toFrame()
        let subscribeFrame = subscribeEndpoint.toFrame()
        
        webSocketService.write(connectFrame) { [weak self] in
            self?.webSocketService.write(subscribeFrame, completion: nil)
        }
        
        return incomingMessage
    }
    
    func unsubscribe(_ endpoint: StompEndpoint) {
        let frame = endpoint.toFrame()
        webSocketService.write(frame, completion: nil)
    }
    
    func send(_ endpoint: StompEndpoint) {
        let frame = endpoint.toFrame()
        webSocketService.write(frame, completion: nil)
    }
}

extension DefaultStompService: WebSocketServiceDelegate {
    func webSocketDidConnect() {
        
    }
    
    func webSocketDidDisconnect() {
        
    }
    
    func webSocketDidReceive(text: String) {
        // stomp send인지 확인하는 로직 필요할듯
        if let jsonString = text.extractJsonString(),
           let data = jsonString.data(using: .utf8) {
            incomingMessage.onNext(data)
        }
    }
}
