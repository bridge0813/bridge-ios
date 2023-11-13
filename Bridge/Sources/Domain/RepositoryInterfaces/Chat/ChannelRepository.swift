//
//  ChannelRepository.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import RxSwift

protocol ChannelRepository {
    func fetchChannels() -> Observable<[Channel]>
    func leaveChannel(id: String) -> Observable<Void>
    
    func observeChannel(id: String) -> Observable<[Message]>
}
