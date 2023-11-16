//
//  ObserveChannelUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 11/14/23.
//

import RxSwift

protocol ObserveChannelUseCase {
    func observe(id: String) -> Observable<Message>
}

final class DefaultObserveChannelUseCase: ObserveChannelUseCase {
    private let channelRepository: ChannelRepository
    
    init(channelRepository: ChannelRepository) {
        self.channelRepository = channelRepository
    }
    
    func observe(id: String) -> Observable<Message> {
        channelRepository.observeChannel(id: id)
    }
}
