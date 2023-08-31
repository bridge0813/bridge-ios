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
    
    func requestTestData() -> Observable<[ChatRoomDTO]>  // 임시
    
    func requestTestProjectsData() -> Observable<[ProjectDTO]> // 임시
}
