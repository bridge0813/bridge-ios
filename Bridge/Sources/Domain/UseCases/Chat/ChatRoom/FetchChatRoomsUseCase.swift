//
//  FetchChatRoomsUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import RxSwift

protocol FetchChatRoomsUseCase {
    func fetchChatRooms() -> Observable<[ChatRoom]>
}

final class DefaultFetchChatRoomsUseCase: FetchChatRoomsUseCase {
    
    private let chatRoomRepository: ChatRoomRepository
    
    init(chatRoomRepository: ChatRoomRepository) {
        self.chatRoomRepository = chatRoomRepository
    }
    
    func fetchChatRooms() -> Observable<[ChatRoom]> {
        chatRoomRepository.fetchChatRooms()
    }
}
