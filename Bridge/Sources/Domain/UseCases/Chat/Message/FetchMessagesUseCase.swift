//
//  FetchMessagesUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 10/22/23.
//

import RxSwift

protocol FetchMessagesUseCase {
    func fetchMessages(channelId: String) -> Observable<[Message]>
}

final class DefaultFetchMessagesUseCase: FetchMessagesUseCase {
    
    private let messageRepository: MessageRepository
    
    init(messageRepository: MessageRepository) {
        self.messageRepository = messageRepository
    }
    
    func fetchMessages(channelId: String) -> Observable<[Message]> {
        messageRepository.fetchMessages(channelID: channelId)
    }   
}
