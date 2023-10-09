//
//  Endpoint.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation

protocol Endpoint {
    var baseURL: URL? { get }
    var path: String { get }
    var queryParameters: QueryParameters? { get }
    
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var tokenStorage: TokenStorage? { get }
    
    var body: Encodable? { get }
    
    func toURLRequest() -> URLRequest?
}

extension Endpoint {
    // TODO: 배포 후 수정
    var baseURL: URL? {
        URL(string: "https://bridge.com")
    }
    
    var headers: HTTPHeaders {
        var defaultHeaders = ["Content-Type": "application/json"]
        
        if let accessToken = tokenStorage?.fetchToken(for: .accessToken) {
            defaultHeaders["Authorization"] = "Bearer \(accessToken)"
        }
        
        return defaultHeaders
    }
    
    var tokenStorage: TokenStorage? {
        KeychainTokenStorage()
    }
 
    func toURLRequest() -> URLRequest? {
        guard let url = configureURL() else { return nil }
        
        return URLRequest(url: url)
            .setMethod(method)
            .appendingHeaders(headers)
            .setBody(body)
    }
    
    private func configureURL() -> URL? {
        baseURL?
            .appendingPathComponent(path)
            .appendingQueries(with: queryParameters)
    }
}

// MARK: - URL+
extension URL {
    func appendingQueries(with queryParameters: QueryParameters?) -> URL? {
        guard let queryParameters, !queryParameters.isEmpty else { return self }
        
        var components = URLComponents(string: self.absoluteString)
        components?.queryItems = queryParameters.map { URLQueryItem(name: $0, value: $1) }
        return components?.url
    }
}

// MARK: - URLRequest+
extension URLRequest {
    func setMethod(_ method: HTTPMethod) -> URLRequest {
        var urlRequest = self
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
    
    func appendingHeaders(_ headers: HTTPHeaders) -> URLRequest {
        var urlRequest = self
        headers.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        return urlRequest
    }
    
    func setBody(_ body: Encodable?) -> URLRequest {
        var urlRequest = self
        
        if let body {
            urlRequest.httpBody = try? JSONEncoder().encode(body)
        }
        
        return urlRequest
    }
}
