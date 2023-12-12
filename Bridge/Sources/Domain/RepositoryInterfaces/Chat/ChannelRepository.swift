//
//  ChannelRepository.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import RxSwift

protocol ChannelRepository {
    func fetchChannels() -> Observable<[Channel]>
    func leaveChannel(id: String) -> Observable<String>
    func createChannel(applicantID: Int) -> Observable<Channel>
    
    func subscribeChannel(id: String) -> Observable<[Message]>
    func unsubscribeChannel(id: String)
}
