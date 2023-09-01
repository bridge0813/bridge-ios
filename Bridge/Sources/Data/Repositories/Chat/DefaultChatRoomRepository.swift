//
//  DefaultChatRoomRepository.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import RxSwift

final class DefaultChatRoomRepository: ChatRoomRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchChatRooms() -> Observable<[ChatRoom]> {
        networkService
            .requestTestChatRooms()
            .map { data -> [ChatRoom] in
                data.compactMap { $0.toModel() }
            }
    }
    
    func leaveChatRoom(id: String) -> Single<Void> {
        networkService
            .leaveChatRoom(id: id)
            .map {
                $0
            }
    }
}
