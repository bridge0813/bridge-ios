//
//  SendMessageUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 11/14/23.
//

import RxSwift

protocol SendMessageUseCase {
    func send(message: String) -> Observable<Void>
}

final class DefaultSendMessageUseCase: SendMessageUseCase {
    
    private let messageRepository: MessageRepository
    
    init(messageRepository: MessageRepository) {
        self.messageRepository = messageRepository
    }
    
    func send(message: String) -> Observable<Void> {
        messageRepository.send(message: message)
    }
}
