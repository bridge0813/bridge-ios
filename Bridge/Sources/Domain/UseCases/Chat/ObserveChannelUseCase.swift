//
//  ObserveChannelUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 10/22/23.
//

import RxSwift

protocol ObserveChannelUseCase {
    func observeChannel(id: String) -> Observable<[Message]>
}

final class DefaultObserveChannelUseCase: ObserveChannelUseCase {
    
    private let channelRepository: ChannelRepository
    
    init(channelRepository: ChannelRepository) {
        self.channelRepository = channelRepository
    }
    
    func observeChannel(id: String) -> Observable<[Message]> {
        channelRepository.observeChannel(id: id)
    }   
}
