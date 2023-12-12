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
    
    func fetchChannels() -> Observable<[Channel]> {
        let userID = tokenStorage.get(.userID)
        let channelEndpoint = ChannelEndpoint.fetchChannels(userID: userID)
        
        return networkService.request(to: channelEndpoint, interceptor: AuthInterceptor())
            .decode(type: [ChannelDTO].self, decoder: JSONDecoder())
            .map { channelDTOs in
                channelDTOs.map { $0.toEntity() }
            }
    }
    
    func leaveChannel(id: String) -> Observable<String> {
        let channelEndpoint = ChannelEndpoint.leaveChannel(id: id)
        
        return networkService.request(to: channelEndpoint, interceptor: AuthInterceptor())
            .map { _ in id }
    }
    
    func createChannel(applicantID: Int) -> Observable<Channel> {
        .just(CreateChannelResponseDTO.testData.toEntity())
    }
    
    func subscribeChannel(id: String) -> Observable<[Message]> {
        let userID = tokenStorage.get(.userID)
        
        let stompSubscribeEndpoint = MessageStompEndpoint.subscribe(
            destination: id,
            userID: userID
        )
        
        return stompService.subscribe(stompSubscribeEndpoint)
            .decode(type: StompMessageUpdateDTO.self, decoder: JSONDecoder())
            .map { $0.toEntity(userID: userID) }
    }
    
    func unsubscribeChannel(id: String) {
        let stompUnsubscribeEndpoint = MessageStompEndpoint.unsubscribe(
            destination: id,
            userID: tokenStorage.get(.userID)
        )
        stompService.unsubscribe(stompUnsubscribeEndpoint)
    }
}
