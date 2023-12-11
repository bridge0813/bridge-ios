//
//  MockChannelRepository.swift
//  Bridge
//
//  Created by 정호윤 on 10/11/23.
//

import Foundation
import RxSwift

final class MockChannelRepository: ChannelRepository {
    func fetchChannels() -> Observable<[Channel]> {
        .just(ChannelDTO.testArray.map { $0.toEntity() })
        //        .error(NetworkError.statusCode(401))
    }
    
    func leaveChannel(id: String) -> Observable<String> {
        .just("")
    }
    
    func subscribeChannel(id: String) -> Observable<[Message]> {
        .just([])
        
    }
    
    func unsubscribeChannel(id: String) { }
}
