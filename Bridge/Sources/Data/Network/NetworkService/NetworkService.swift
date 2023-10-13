//
//  NetworkService.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation
import RxSwift

protocol NetworkService: ProjectNetworkService {
    /// Interceptor가 필요 없는 경우 nil을 할당
    func request(_ endpoint: Endpoint, interceptor: Interceptor?) -> Observable<Data>
}

// TODO: 프로토콜 제거 및 network service의 상속 제거
protocol ProjectNetworkService {
    func requestTestProjectsData() -> Observable<[ProjectDTO]>
    func requestTestHotProjectsData() -> Observable<[ProjectDTO]>
}
