//
//  ChannelSubscriptionUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 11/14/23.
//

import RxSwift

protocol ChannelSubscriptionUseCase {
    func subscribe(id: String) -> Observable<[Message]>
    func unsubscribe(id: String)
}

final class DefaultChannelSubscriptionUseCase: ChannelSubscriptionUseCase {
    
    private let channelRepository: ChannelRepository
    
    init(channelRepository: ChannelRepository) {
        self.channelRepository = channelRepository
    }
    
    func subscribe(id: String) -> Observable<[Message]> {
        channelRepository.subscribeChannel(id: id)
    }
    
    func unsubscribe(id: String) {
        channelRepository.unsubscribeChannel(id: id)
    }
}
