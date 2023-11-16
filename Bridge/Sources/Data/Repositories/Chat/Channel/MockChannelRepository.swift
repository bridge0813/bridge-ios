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
        Observable.create { observer in
            if let index = ChannelDTO.testArray.firstIndex(where: { $0.id == id }) {
                ChannelDTO.testArray.remove(at: index)
                observer.onNext(id)
            } else {
                observer.onError(NetworkError.unknown)
            }
            
            return Disposables.create()
        }
    }
    
    func observeChannel(id: String) -> Observable<Message> {
        Observable<Int>.interval(.seconds(2), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .map { _ in
                MessageResponseDTO(
                    content: "일정 간격으로 방출되는 메시지",
                    sender: .opponent,
                    sentDateAndTime: "2023-11-16T11:30:00"
                )
                .toEntity()
            }
    }
}