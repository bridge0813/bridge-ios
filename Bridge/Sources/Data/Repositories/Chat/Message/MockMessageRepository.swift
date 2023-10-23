//
//  MockMessageRepository.swift
//  Bridge
//
//  Created by 정호윤 on 10/22/23.
//

import RxSwift

final class MockMessageRepository: MessageRepository {
    func observe(chatRoomID: String) -> Observable<[Message]> {
        .just([
            // TODO: dto로 수정
            Message(id: "1", sender: .me, type: .text("안녕"), sentTime: "오후 1:00", state: .unread),
            Message(id: "2", sender: .opponent, type: .text("안녕안녕"), sentTime: "오후 1:00", state: .unread),
            Message(id: "3", sender: .me, type: .text("내가 보내는 두 번째 메시지"), sentTime: "오후 1:00", state: .unread),
            Message(id: "4", sender: .opponent, type: .text("상대방이 보내는 두 번째 메시지"), sentTime: "오후 1:00", state: .unread),
            Message(
                id: "5",
                sender: .opponent,
                type: .text("긴 메시지에 대한 테스트긴 메시지에 대한 테스트긴 메시지에 대한 테스트긴 메시지에 대한 테스트긴 메시지에 대한 테스트긴 메시지에 대한 테스트긴 메시지에 대한 테스트긴 메시지에 대한 테스트"), 
                sentTime: "오후 1:00",
                state: .unread
            ),
            Message(id: "6", sender: .me, type: .text("내가 보내는 메시지"), sentTime: "오후 1:00", state: .unread),
            Message(id: "7", sender: .opponent, type: .text("상대방이 보내는 메시지"), sentTime: "오후 1:00", state: .unread),
            Message(id: "8", sender: .opponent, type: .text("상대방이 보내는 메시지"), sentTime: "오후 1:00", state: .unread)
        ])
    }
}
