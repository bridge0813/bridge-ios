//
//  NetworkService.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation
import RxSwift

typealias NetworkService = BasicNetworkService & ProjectNetworkService & ChatNetworkService

protocol BasicNetworkService {
    /// response body에 데이터가 없고, 성공 여부만 반환하는 함수
    func request(_ endpoint: Endpoint) -> Single<Void>
    
    /// response body에 데이터가 있고, 해당 데이터를 디코딩해 반환하는 함수
    func request<T: Decodable>(_ endpoint: Endpoint) -> Single<T>
}

// TODO: 아래 함수들 제거
protocol ProjectNetworkService {
    func requestTestProjectsData() -> Observable<[ProjectDTO]>
    func requestTestHotProjectsData() -> Observable<[ProjectDTO]>
}

protocol ChatNetworkService {
    func requestTestChatRooms() -> Observable<[ChatRoomDTO]>
    func leaveChatRoom(id: String) -> Single<Void>
}
