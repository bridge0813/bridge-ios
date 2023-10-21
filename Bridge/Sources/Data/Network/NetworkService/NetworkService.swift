//
//  NetworkService.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation
import RxSwift

protocol NetworkService {
    /// Interceptor가 필요 없는 경우 nil을 할당
    func request(_ endpoint: Endpoint, interceptor: Interceptor?) -> Observable<Data>
}
