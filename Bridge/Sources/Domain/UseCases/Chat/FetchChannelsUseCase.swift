//
//  FetchChannelsUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import RxSwift

protocol FetchChannelsUseCase {
    func fetchChannels() -> Observable<[Channel]>
}

final class DefaultFetchChannelsUseCase: FetchChannelsUseCase {
    
    private let channelRepository: ChannelRepository
    
    init(channelRepository: ChannelRepository) {
        self.channelRepository = channelRepository
    }
    
    func fetchChannels() -> Observable<[Channel]> {
        channelRepository.fetchChannels()
    }
}
