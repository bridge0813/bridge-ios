//
//  DefaultChannelRepository.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import Foundation
import RxSwift

final class DefaultChannelRepository: ChannelRepository {
    
    private let networkService: NetworkService
    private let tokenStorage: TokenStorage
    
    init(networkService: NetworkService, tokenStorage: TokenStorage = KeychainTokenStorage()) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
    
    func fetchChannels() -> Observable<[Channel]> {
        let userID = tokenStorage.get(.userID) ?? invalidToken
        let chatEndpoint = ChatEndpoint.channels(userID: userID)
    
        return networkService.request(chatEndpoint, interceptor: AuthInterceptor())
            .decode(type: [ChannelDTO].self, decoder: JSONDecoder())
            .map { channelDTOs in
                channelDTOs.map { $0.toEntity() }
            }
    }
    
    func leaveChannel(id: String) -> Observable<Void> {
        let chatEndpoint = ChatEndpoint.leaveChannel(id: id)
        
        return networkService.request(chatEndpoint, interceptor: AuthInterceptor())
            .map { _ in }
    }
    
    // TODO: 구현
    func observeChannel(id: String) -> Observable<[Message]> {
        .just([])
    }
}
