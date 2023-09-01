//
//  FetchChatRoomsUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import RxSwift

protocol FetchChatRoomsUseCase {
    func execute() -> Observable<[ChatRoom]>
}

final class DefaultFetchChatRoomsUseCase: FetchChatRoomsUseCase {
    
    private let chatRoomRepository: ChatRoomRepository
    
    init(chatRoomRepository: ChatRoomRepository) {
        self.chatRoomRepository = chatRoomRepository
    }
    
    func execute() -> Observable<[ChatRoom]> {
        chatRoomRepository.fetchChatRooms()
    }
}
