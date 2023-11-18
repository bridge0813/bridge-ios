//
//  DefaultNetworkService.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation
import RxCocoa
import RxSwift

final class DefaultNetworkService: NetworkService {
    
    func request(to endpoint: Endpoint, interceptor: Interceptor?) -> Observable<Data> {
        guard var request = endpoint.toURLRequest() else { return .error(NetworkError.invalidRequest) }
        
        interceptor?.adapt(&request)
        
        return URLSession.shared.rx.response(request: request)
            .flatMap { httpResponse, data in
                let statusCode = httpResponse.statusCode
                
                switch statusCode {
                case 200 ..< 300:
                    return Observable.just(data)
                    
                case 401:
                    return interceptor?.retry(request, data: data) ?? Observable.error(NetworkError.statusCode(statusCode))
                    
                default:
                    return Observable.error(NetworkError.statusCode(statusCode))
                }
            }
    }
}
