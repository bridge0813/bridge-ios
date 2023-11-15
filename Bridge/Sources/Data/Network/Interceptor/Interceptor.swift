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
    /// 요청을 다시 시도하는 함수
    func retry(_ request: URLRequest, data: Data) -> Observable<Data>
}
