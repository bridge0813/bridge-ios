//
//  ObserveChatRoomUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/31.
//

import Foundation
import RxSwift

/// 특정 채팅방을 관찰하는 유스케이스
protocol ObserveChatRoomUseCase {
    func execute(id: String) -> Observable<ChatRoom>
}

final class DefaultObserveChatRoomUseCase: ObserveChatRoomUseCase {
    
    private let chatRoomRepository: ChatRoomRepository
    
    init(chatRoomRepository: ChatRoomRepository) {
        self.chatRoomRepository = chatRoomRepository
    }
    
    func execute(id: String) -> Observable<ChatRoom> {
        chatRoomRepository.observeChatRoom(id: id)
    }
}
