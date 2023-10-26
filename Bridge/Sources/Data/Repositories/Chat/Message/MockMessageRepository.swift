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
            Message(
                id: "0",
                sender: .me,
                type: .text("안녕"),
                sentDate: "2023년 10월 25일 수요일",
                sentTime: "오후 1:00",
                state: .unread
            ),
            Message(
                id: "1",
                sender: .opponent,
                type: .text("안녕"),
                sentDate: "2023년 10월 25일 수요일",
                sentTime: "오후 1:00",
                state: .unread
            ),
            Message(
                id: "2",
                sender: .me,
                type: .text("내가 보내는 메시지"),
                sentDate: "2023년 10월 25일 수요일",
                sentTime: "오후 1:00",
                state: .unread
            ),
            Message(
                id: "3",
                sender: .opponent,
                type: .text("상대방이 보내는 메시지"),
                sentDate: "2023년 10월 25일 수요일",
                sentTime: "오후 1:00",
                state: .unread
            ),
            Message(
                id: "4",
                sender: .opponent,
                type: .text(
                """
                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
                """),
                sentDate: "2023년 10월 26일 목요일",
                sentTime: "오후 1:00",
                state: .unread
            ),
            Message(
                id: "5",
                sender: .opponent,
                type: .text("안녕"),
                sentDate: "2023년 10월 26일 목요일",
                sentTime: "오후 1:00",
                state: .unread
            ),
            Message(
                id: "6",
                sender: .me,
                type: .text("내가 보내는 메시지"),
                sentDate: "2023년 10월 26일 목요일",
                sentTime: "오후 1:00",
                state: .unread
            ),
            Message(
                id: "7",
                sender: .opponent,
                type: .text("상대방이 보내는 메시지"),
                sentDate: "2023년 10월 26일 목요일",
                sentTime: "오후 1:00",
                state: .unread
            ),
            Message(
                id: "8",
                sender: .opponent,
                type: .text("상대방이 보내는 메시지"),
                sentDate: "2023년 10월 26일 목요일",
                sentTime: "오후 1:00",
                state: .unread
            ),
            Message(
                id: "9",
                sender: .opponent,
                type: .text("상대방이 보내는  메시지"),
                sentDate: "2023년 10월 26일 목요일",
                sentTime: "오후 1:00",
                state: .unread
            )
        ])
    }
}
