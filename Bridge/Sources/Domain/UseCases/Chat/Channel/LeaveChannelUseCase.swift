//
//  LeaveChannelUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import RxSwift

protocol LeaveChannelUseCase {
    func leaveChannel(id: String) -> Observable<Void>
}

final class DefaultLeaveChannelUseCase: LeaveChannelUseCase {
    
    private let channelRepository: ChannelRepository
    
    init(channelRepository: ChannelRepository) {
        self.channelRepository = channelRepository
    }
    
    func leaveChannel(id: String) -> Observable<Void> {
        channelRepository.leaveChannel(id: id)
    }
}
