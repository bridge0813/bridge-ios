//
//  ChatRoomRepository.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import RxSwift

protocol ChatRoomRepository {
    func fetchChatRooms() -> Observable<[ChatRoom]>
    func leaveChatRoom() -> Single<Void>
}
