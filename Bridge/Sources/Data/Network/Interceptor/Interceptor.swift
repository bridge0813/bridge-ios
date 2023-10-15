//
//  Interceptor.swift
//  Bridge
//
//  Created by 정호윤 on 10/11/23.
//

import Foundation
import RxSwift

protocol Interceptor: Adapter, Retrier { }

protocol Adapter {
    /// Request에 원하는 설정을 추가하는 함수
    func adapt(_ request: inout URLRequest)
}

protocol Retrier {
    /// Response를 확인해 요청을 재시도할지 결정하는 함수
    func shouldRetry(_ request: URLRequest, httpResponse: HTTPURLResponse, data: Data) -> Observable<Data>
}
