//
//  ObserveMessageUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 11/23/23.
//

import RxSwift

protocol ObserveMessageUseCase {
    func observeMessage() -> Observable<Message>
}

final class DefaultObserveMessageUseCase: ObserveMessageUseCase {
    
    private let messageRepository: MessageRepository
    
    init(messageRepository: MessageRepository) {
        self.messageRepository = messageRepository
    }
    
    func observeMessage() -> Observable<Message> {
        messageRepository.observeMessage()
    }
}
