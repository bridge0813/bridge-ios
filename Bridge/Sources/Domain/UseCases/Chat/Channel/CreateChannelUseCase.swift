//
//  CreateChannelUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/12/23.
//

import RxSwift

protocol CreateChannelUseCase {
    func create(applicantID: Int) -> Observable<Channel>
}

final class DefaultCreateChannelUseCase: CreateChannelUseCase {
    
    private let channelRepository: ChannelRepository
    
    init(channelRepository: ChannelRepository) {
        self.channelRepository = channelRepository
    }
    
    func create(applicantID: Int) -> Observable<Channel> {
        channelRepository.createChannel(applicantID: applicantID)
    }
}
