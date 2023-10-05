//
//  NetworkService.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation
import RxSwift

typealias NetworkService = BasicNetworkService & AuthNetworkService & ProjectNetworkService & ChatNetworkService

protocol BasicNetworkService {
    func request(_ endpoint: Endpoint) -> Observable<Data>
}

protocol AuthNetworkService {
    func signInWithApple(userName: String?, credentials: UserCredentials) -> Single<SignInResponseDTO>
    func signInWithAppleTest(userName: String?, credentials: UserCredentials) -> Single<SignInResponseDTO>
}

protocol ProjectNetworkService {
    func requestTestProjectsData() -> Observable<[ProjectDTO]>
    func requestTestHotProjectsData() -> Observable<[ProjectDTO]>
}

protocol ChatNetworkService {
    func requestTestChatRooms() -> Observable<[ChatRoomDTO]>
    func leaveChatRoom(id: String) -> Single<Void>
}
