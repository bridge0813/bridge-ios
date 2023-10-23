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
    private let tokenStorage: TokenStorage
    
    init(networkService: NetworkService, tokenStorage: TokenStorage = KeychainTokenStorage()) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
    
    func fetchChatRooms() -> Observable<[ChatRoom]> {
        let userID = tokenStorage.get(.userID) ?? ""
        let chatEndpoint = ChatEndpoint.chatRooms(userID: userID)
    
        return networkService.request(chatEndpoint, interceptor: AuthInterceptor())
            .decode(type: [ChatRoomDTO].self, decoder: JSONDecoder())
            .map { chatRoomDTOs in
                chatRoomDTOs.map { $0.toEntity() }
            }
    }
    
    func leaveChatRoom(id: String) -> Observable<Void> {
        let chatEndpoint = ChatEndpoint.leaveChatRoom(chatRoomID: id)
        
        return networkService.request(chatEndpoint, interceptor: AuthInterceptor())
            .map { _ in }
    }
}
