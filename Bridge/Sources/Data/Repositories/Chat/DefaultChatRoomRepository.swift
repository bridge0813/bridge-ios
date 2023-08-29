//
//  DefaultChatRoomRepository.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import Foundation
import RxSwift

final class DefaultChatRoomRepository: ChatRoomRepository {
    
    // TODO: newtwork service 의존성에서 아래 작업 해야함
    
    func fetchChatRooms() -> Observable<[ChatRoom]> {
        Observable.just([
            ChatRoom(
                id: "1",
                profileImage: nil,
                name: "정호윤",
                time: Date(),
                messageType: .text,
                preview: "안녕하세요!"
            )
        ])
    }
    
    func leaveChatRoom() -> Single<Void> {
        .just(())
    }
}
