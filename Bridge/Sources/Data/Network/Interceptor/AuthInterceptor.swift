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
        let accessToken = tokenStorage.get(.accessToken) ?? invalidToken
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
    
    func shouldRetry(_ request: URLRequest, httpResponse: HTTPURLResponse, data: Data) -> Observable<Data> {
        if httpResponse.statusCode == 401 {
            return retry(request, data: data)
        } else {
            return .just(data)
        }
    }
    
    private func retry(_ request: URLRequest, data: Data) -> Observable<Data> {
        let refreshToken = tokenStorage.get(.refreshToken) ?? invalidToken
        
        var request = request
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization-refresh")
        
        return URLSession.shared.rx.data(request: request)
            .flatMap { data in
                let accessTokenResponseDTO = try? JSONDecoder().decode(AccessTokenResponseDTO.self, from: data)
                let accessToken = accessTokenResponseDTO?.accessToken ?? invalidToken
                tokenStorage.save(accessToken, for: .accessToken)
                request.setValue(nil, forHTTPHeaderField: "Authorization-refresh")  // 헤더 제거
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                return URLSession.shared.rx.data(request: request)
            }
    }
}
