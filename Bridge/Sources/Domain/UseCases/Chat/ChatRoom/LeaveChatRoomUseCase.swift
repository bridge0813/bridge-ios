//
//  LeaveChatRoomUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import RxSwift

protocol LeaveChatRoomUseCase {
    func execute(id: String) -> Observable<Void>
}

final class DefaultLeaveChatRoomUseCase: LeaveChatRoomUseCase {
    
    private let chatRoomRepository: ChatRoomRepository
    
    init(chatRoomRepository: ChatRoomRepository) {
        self.chatRoomRepository = chatRoomRepository
    }
    
    func execute(id: String) -> Observable<Void> {
        chatRoomRepository.leaveChatRoom().asObservable()
    }
}
