//
//  DefaultNetworkService.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation
import RxSwift

final class DefaultNetworkService: NetworkService {
    func request(_ endpoint: Endpoint) -> Observable<Data> {
        guard let urlRequest = endpoint.toURLRequest() else { return .error(NetworkError.invalidURL) }
        return URLSession.shared.rx.data(request: urlRequest).asObservable()
    }
    
    // MARK: - For test
    func requestTestChatRooms() -> Observable<[ChatRoomDTO]> {
        Observable.just(ChatRoomDTO.testArray)
    }
    
    func leaveChatRoom(id: String) -> Single<Void> {
        Single.create { single in
            
            if let index = ChatRoomDTO.testArray.firstIndex(where: { $0.id == id }) {
                ChatRoomDTO.testArray.remove(at: index)
                single(.success(()))
            } else {
                single(.failure(NetworkError.unknown))
            }
            
            return Disposables.create()
        }
    }
    
    func requestTestProjectsData() -> Observable<[AllProjectDTO]> {
        Observable.just(AllProjectDTO.projectTestArray)
    }
    
    func requestTestHotProjectsData() -> Observable<[HotProjectDTO]> {
        Observable.just(HotProjectDTO.hotProjectTestArray)
    }
    
}
