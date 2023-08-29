//
//  DefaultChatRoomRepository.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import Foundation
import RxSwift

final class DefaultChatRoomRepository: ChatRoomRepository {
    
    private let chatRoomNetworkService: ChatRoomNetworkService
    
    init(chatRoomNetworkService: ChatRoomNetworkService) {
        self.chatRoomNetworkService = chatRoomNetworkService
    }
    
    func fetchChatRooms() -> Observable<[ChatRoom]> {
        chatRoomNetworkService
            .requestTestData()
            .map { data -> [ChatRoom] in data.compactMap { $0.toModel() } }
    }
    
    func leaveChatRoom() -> Single<Void> {
        .just(())
    }
}
