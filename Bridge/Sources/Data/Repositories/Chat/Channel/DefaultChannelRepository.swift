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
    private let webSocketService: WebSocketService
    private let tokenStorage: TokenStorage
    
    init(
        networkService: NetworkService,
        webSocketService: WebSocketService,
        tokenStorage: TokenStorage = KeychainTokenStorage()
    ) {
        self.networkService = networkService
        self.webSocketService = webSocketService
        self.tokenStorage = tokenStorage
    }
    
    func fetchChannels() -> Observable<[Channel]> {
        let userID = tokenStorage.get(.userID)
        let channelEndpoint = ChannelEndpoint.channels(userID: userID)
    
        return networkService.request(channelEndpoint, interceptor: AuthInterceptor())
            .decode(type: [ChannelDTO].self, decoder: JSONDecoder())
            .map { channelDTOs in
                channelDTOs.map { $0.toEntity() }
            }
    }
    
    func leaveChannel(id: String) -> Observable<String> {
        let channelEndpoint = ChannelEndpoint.leaveChannel(id: id)
        
        return networkService.request(channelEndpoint, interceptor: AuthInterceptor())
            .map { _ in id }
    }
    
    func observeChannel(id: String) -> Observable<Message> {
        let messageStompEndpoint = MessageStompEndpoint.subscribe(destination: id)
        webSocketService.subscribe(messageStompEndpoint)
        return .just(.onError)
    }
}
