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
        //        .just(StompMessageResponseDTO.testData.toEntity(userID: "1"))
        Observable<Int>.interval(.seconds(2), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .map { _ in
                StompMessageResponseDTO(
                    messageID: UUID().uuidString,
                    channelID: "1",
                    senderID: 1,
                    type: "TALK",
                    content: "일정 간격으로 방출되는 메시지",
                    sentDateAndTime: "2023-11-16T11:30:00",
                    hasRead: true
                )
                .toEntity(userID: "1")
                
            }
    }
    
    func sendMessage(_ message: String, to channel: String) { }
}
