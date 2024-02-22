//
//  DefaultMessageRepository.swift
//  Bridge
//
//  Created by 정호윤 on 11/13/23.
//

import Foundation
import RxSwift

final class DefaultMessageRepository: MessageRepository {
    
    private let networkService: NetworkService
    private let stompService: StompService
    private let tokenStorage: TokenStorage
    
    init(
        networkService: NetworkService,
        stompService: StompService,
        tokenStorage: TokenStorage = KeychainTokenStorage()
    ) {
        self.networkService = networkService
        self.stompService = stompService
        self.tokenStorage = tokenStorage
    }
    
    func fetchMessages(channelID: String) -> Observable<[Message]> {
        let messageEndpoint = MessageEndpoint.fetchMessages(channelID: channelID)
        
        return networkService.request(to: messageEndpoint, interceptor: AuthInterceptor())
            .decode(type: MessageDTO.self, decoder: JSONDecoder())
            .map { [weak self] messageDTO in
                let userID = self?.tokenStorage.get(.userID) ?? invalidToken
                return messageDTO.toEntity(userID: userID)
            }
    }
    
    func observeMessage() -> Observable<Message> {
        let userID = tokenStorage.get(.userID)
        
        return stompService.observe()
            .decode(type: StompMessageResponseDTO.self, decoder: JSONDecoder())
            .map { $0.toEntity(userID: userID) }
    }
    
    func sendMessage(_ message: String, to channel: String) {
        let userID = tokenStorage.get(.userID)
        
        let messageRequestDTO = StompMessageRequestDTO(
            channelID: channel,
            senderID: userID,
            type: .talk,
            content: message
        )
        let messageStompEndpoint = MessageStompEndpoint.send(requestDTO: messageRequestDTO)
        
        stompService.send(messageStompEndpoint)
    }
}
