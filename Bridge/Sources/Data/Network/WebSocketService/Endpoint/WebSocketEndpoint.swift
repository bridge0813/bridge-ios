//
//  WebSocketEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 10/18/23.
//

import Foundation

protocol WebSocketEndpoint {
    typealias Headers = [String: String]
    
    var baseURL: URL? { get }
    var requestHeaders: Headers? { get }
    var timeoutInterval: TimeInterval { get }
    
    func toURLRequest() -> URLRequest?
}

extension WebSocketEndpoint {
    var baseURL: URL? {
        URL(string: "ws://169.254.210.65:1337/")
    }
    
    var timeoutInterval: TimeInterval { 5 }
    
    func toURLRequest() -> URLRequest? {
        guard let url = baseURL else { return nil }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = timeoutInterval
        
        if let requestHeaders {
            for (header, value) in requestHeaders {
                request.setValue(value, forHTTPHeaderField: header)
            }
        }
        
        return request
    }
}
