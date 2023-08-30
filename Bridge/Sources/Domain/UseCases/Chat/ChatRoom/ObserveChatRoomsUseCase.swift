//
//  ObserveChatRoomsUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import Foundation
import RxSwift

protocol ObserveChatRoomsUseCase {
    func execute() -> Observable<[ChatRoom]>
}

final class DefaultObserveChatRoomsUseCase: ObserveChatRoomsUseCase {
    
    private let chatRoomRepository: ChatRoomRepository
    
    init(chatRoomRepository: ChatRoomRepository) {
        self.chatRoomRepository = chatRoomRepository
    }
    
    func execute() -> Observable<[ChatRoom]> {
        chatRoomRepository.observeChatRooms()
    }
}
