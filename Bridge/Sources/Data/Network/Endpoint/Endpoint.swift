//
//  Endpoint.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation

protocol Endpoint {
    var method: HTTPMethod { get }
    var baseURL: URL? { get }
    var path: String { get }
    
    var headers: HTTPHeaders { get }
    var accessToken: String { get }
    var parameters: HTTPRequestParameter? { get }
    
    func toURLRequest() -> URLRequest?
}

extension Endpoint {
    var accessToken: String { "" }
    
    var headers: HTTPHeaders {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    }
 
    func toURLRequest() -> URLRequest? {
        guard let url = configureURL() else { return nil }
        return URLRequest(url: url).setMethod(method).appendingHeaders(headers).setBody(using: parameters)
    }
    
    private func configureURL() -> URL? {
        baseURL?.appendingPathComponent(path).appendingQueries(with: parameters)
    }
}

extension URL {
    func appendingQueries(with parameter: HTTPRequestParameter?) -> URL? {
        var components = URLComponents(string: self.absoluteString)
        
        if case .query(let queries) = parameter {
            components?.queryItems = queries.map { URLQueryItem(name: $0, value: $1) }
        }
        
        return components?.url
    }
}

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
    
    func setBody(using parameter: HTTPRequestParameter?) -> URLRequest {
        var urlRequest = self
        
        if case .body(let body) = parameter {
            urlRequest.httpBody = try? JSONEncoder().encode(body)
        }
        
        return urlRequest
    }
}
