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
    
    func leaveChannel(id: String) -> Observable<Void> {
        Observable.create { observer in
            if let index = ChannelDTO.testArray.firstIndex(where: { $0.id == id }) {
                ChannelDTO.testArray.remove(at: index)
                observer.onNext(())
            } else {
                observer.onError(NetworkError.unknown)
            }
            
            return Disposables.create()
        }
    }
    
    // MARK: - DTO로 수정
    func observe(id: String) -> Observable<Message> {
        Observable<Int>.interval(.seconds(2), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .map { _ in
                Message(
                    id: UUID().uuidString,
                    sender: .opponent,
                    type: .text("ads"),
                    sentDate: "2023-12-01",
                    sentTime: "오전 12:00",
                    state: .unread
                )
            }
    }
}
