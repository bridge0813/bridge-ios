//
//  MockMessageRepository.swift
//  Bridge
//
//  Created by 정호윤 on 11/13/23.
//

import Foundation
import RxSwift

final class MockMessageRepository: MessageRepository {
    func fetchMessages(channelID: String) -> Observable<[Message]> {
        .just(MessageDTO.testData.toEntity(userID: "1"))
    }
    
    func observeMessage() -> Observable<Message> {
        .just(StompMessageResponseDTO.testData.toEntity(userID: "1"))
    }
    
    func sendMessage(_ message: String, to channel: String) { }
}
