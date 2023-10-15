//
//  MockChatRoomRepository.swift
//  Bridge
//
//  Created by 정호윤 on 10/11/23.
//

import RxSwift

final class MockChatRoomRepository: ChatRoomRepository {
    func fetchChatRooms() -> Observable<[ChatRoom]> {
        .just(ChatRoomDTO.testArray.map { $0.toEntity() })
//        .error(NetworkError.statusCode(401))
    }
    
    func leaveChatRoom(id: String) -> Observable<Void> {
        Observable.create { observer in
            if let index = ChatRoomDTO.testArray.firstIndex(where: { $0.id == id }) {
                ChatRoomDTO.testArray.remove(at: index)
                observer.onNext(())
            } else {
                observer.onError(NetworkError.unknown)
            }
            
            return Disposables.create()
        }
    }
}
