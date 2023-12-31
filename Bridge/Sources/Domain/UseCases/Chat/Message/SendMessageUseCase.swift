//
//  SendMessageUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 11/14/23.
//

import RxSwift

protocol SendMessageUseCase {
    func sendMessage(_ message: String, to channel: String)
}

final class DefaultSendMessageUseCase: SendMessageUseCase {
    
    private let messageRepository: MessageRepository
    
    init(messageRepository: MessageRepository) {
        self.messageRepository = messageRepository
    }
    
    func sendMessage(_ message: String, to channel: String) {
        messageRepository.sendMessage(message, to: channel)
    }
}
