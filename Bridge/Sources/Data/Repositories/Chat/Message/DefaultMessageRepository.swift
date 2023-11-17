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
        let messageEndpoint = MessageEndpoint.messages(channelID: channelID)
        
        return networkService.request(messageEndpoint, interceptor: nil)
            .decode(type: [MessageResponseDTO].self, decoder: JSONDecoder())
            .map { messageDTOs in
                messageDTOs.map { $0.toEntity() }
            }
    }
    
    func sendMessage(_ message: String, to channel: String) -> Observable<Void> {
        let messageRequestDTO = MessageRequestDTO(
            channelID: channel,
            type: .talk,
            sender: tokenStorage.get(.userName),
            content: message
        )
        
        let messageStompEndpoint = MessageStompEndpoint.sendMessage(requestDTO: messageRequestDTO)
        stompService.send(messageStompEndpoint)
        return .just(())
    }
}
