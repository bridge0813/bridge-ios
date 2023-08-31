//
//  NetworkService.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation
import RxSwift

protocol NetworkService {
    func request(_ endpoint: Endpoint) -> Observable<Data>
    
    // MARK: - For test
    func requestTestProjectsData() -> Observable<[ProjectDTO]>
    func requestTestChatRoom(id: String) -> Observable<ChatRoomDTO>
    func requestTestChatRooms() -> Observable<[ChatRoomDTO]>
}
