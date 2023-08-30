//
//  DefaultChatRoomRepository.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import Foundation
import RxSwift

final class DefaultChatRoomRepository: ChatRoomRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func observeChatRooms() -> Observable<[ChatRoom]> {
        networkService
            .requestTestData()
            .map { data -> [ChatRoom] in data.compactMap { $0.toModel() } }
    }
    
    func leaveChatRoom() -> Single<Void> {
        .just(())
    }
}
