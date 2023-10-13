//
//  DefaultNetworkService.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation
import RxSwift

final class DefaultNetworkService: NetworkService {
    
    func request(_ endpoint: Endpoint, interceptor: Interceptor?) -> Observable<Data> {
        guard var request = endpoint.toURLRequest() else { return .error(NetworkError.invalidRequest) }
        
        interceptor?.adapt(&request)
        
        return URLSession.shared.rx.response(request: request)
            .flatMap { httpResponse, data in
                interceptor?.shouldRetry(request, httpResponse: httpResponse, data: data) ?? .just(data)
            }
    }
}

// TODO: 아래 함수들 제거
extension DefaultNetworkService {    
    func requestTestProjectsData() -> Observable<[ProjectDTO]> {
        Observable.just(ProjectDTO.projectTestArray)
    }
    
    func requestTestHotProjectsData() -> Observable<[ProjectDTO]> {
        Observable.just(ProjectDTO.hotProjectTestArray)
    }
}
