//
//  HTTP.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

enum HTTPMethod: String {
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

typealias HTTPHeaders = [String: String]
typealias QueryParameters = [String: String]

enum HTTPRequestParameter {
    case query([String: String])
    case body(Encodable)
}
