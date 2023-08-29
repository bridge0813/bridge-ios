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
    
    func requestTestData() -> Observable<[ChatRoomDTO]> {
        Observable.just([
            ChatRoomDTO(
                id: "1",
                profileImage: nil,
                name: "정호윤",
                time: Date(),
                messageType: .text,
                messagePreview: "메시지 미리보기 1"
            ),
            ChatRoomDTO(
                id: "2",
                profileImage: nil,
                name: "엄지호",
                time: Date(),
                messageType: .text,
                messagePreview: "메시지 미리보기 2"
            ),
            ChatRoomDTO(
                id: "3",
                profileImage: nil,
                name: "홍길동",
                time: Date(),
                messageType: .text,
                messagePreview: "메시지 미리보기 3"
            )
        ])
    }
}
