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
    private let tokenStorage: TokenStorage
    
    init(networkService: NetworkService, tokenStorage: TokenStorage = KeychainTokenStorage()) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
    
    func fetchMessages(channelID: String) -> Observable<[Message]> {
        let messageEndpoint = MessageEndpoint.messages(channelID: channelID)
        
        return networkService.request(messageEndpoint, interceptor: nil)
            .decode(type: [MessageDTO].self, decoder: JSONDecoder())
            .map { messageDTOs in
                messageDTOs.map { $0.toEntity() }
            }
    }
}
