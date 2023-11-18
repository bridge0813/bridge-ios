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
    
    func unsubscribe(_ disconnectEndpoint: StompEndpoint, _ unsubscribeEndpoint: StompEndpoint) {
        let disconnectFrame = disconnectEndpoint.toFrame()
        let unsubscribeFrame = unsubscribeEndpoint.toFrame()
        
        webSocketService.write(unsubscribeFrame) { [weak self] in
            self?.webSocketService.write(disconnectFrame, completion: nil)
        }
    }
    
    func send(_ endpoint: StompEndpoint) {
        let frame = endpoint.toFrame()
        webSocketService.write(frame, completion: nil)
    }
}

extension DefaultStompService: WebSocketServiceDelegate {
    func webSocketDidReceive(text: String) {
        guard let command = text.extractCommand(.message),
              command == StompResponseCommand.message.rawValue,
              let jsonString = text.extractJsonString(),
              let data = jsonString.data(using: .utf8) 
        else { return }
        
        incomingMessage.onNext(data)
    }
    
    func webSocketDidReceive(data: Data) { }
}
