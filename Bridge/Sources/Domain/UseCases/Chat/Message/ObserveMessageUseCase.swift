//
//  ObserveMessageUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 10/22/23.
//

import RxSwift

protocol ObserveMessageUseCase {
    func observe(chatRoomID: String) -> Observable<[Message]>
}

final class DefaultObserveMessageUseCase: ObserveMessageUseCase {
    
    private let messageRepository: MessageRepository
    
    init(messageRepository: MessageRepository) {
        self.messageRepository = messageRepository
    }
    
    func observe(chatRoomID: String) -> Observable<[Message]> {
        messageRepository.observe(chatRoomID: chatRoomID)
    }   
}
