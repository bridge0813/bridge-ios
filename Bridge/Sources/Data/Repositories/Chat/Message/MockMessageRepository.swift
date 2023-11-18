//
//  MockMessageRepository.swift
//  Bridge
//
//  Created by 정호윤 on 11/13/23.
//

import RxSwift

final class MockMessageRepository: MessageRepository {
    func fetchMessages(channelID: String) -> Observable<[Message]> {
        .just(MessageDTO.testArray.map { $0.toEntity() })
    }
    
    func sendMessage(_ message: String, to channel: String) { }
}
