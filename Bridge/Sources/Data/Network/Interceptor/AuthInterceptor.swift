//
//  AuthInterceptor.swift
//  Bridge
//
//  Created by 정호윤 on 10/11/23.
//

import Foundation
import RxSwift

struct AuthInterceptor: Interceptor {
    
    private let tokenStorage: TokenStorage
    
    init(tokenStorage: TokenStorage = KeychainTokenStorage()) {
        self.tokenStorage = tokenStorage
    }
    
    func adapt(_ request: inout URLRequest) {
        guard let accessToken = tokenStorage.get(.accessToken) else { return }
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
    
    func shouldRetry(_ request: URLRequest, httpResponse: HTTPURLResponse, data: Data) -> Observable<Data> {
        if httpResponse.statusCode == 401 {
            return retry(request, data: data)
        } else {
            return .just(data)
        }
    }
    
    private func retry(_ request: URLRequest, data: Data) -> Observable<Data> {
        guard let refreshToken = tokenStorage.get(.refreshToken) else { return .just(data) }
        
        var request = request
        request.addValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization-refresh")
        
        return URLSession.shared.rx.response(request: request)
            .flatMap { httpResponse, data in
                if httpResponse.statusCode == 200 {
                    let accessToken = String(data: data, encoding: .utf8)
                    tokenStorage.save(accessToken ?? "", for: .accessToken)
                    
                    adapt(&request)
                    
                    return URLSession.shared.rx.data(request: request)
                } else {
                    return Observable.error(NetworkError.unauthorized)
                }
            }
    }
}
