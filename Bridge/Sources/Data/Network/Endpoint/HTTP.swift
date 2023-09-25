//
//  HTTP.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

enum HTTPMethod: String {
    case GET
    case POST, PUT, PATCH
    case DELETE
}

typealias HTTPHeaders = [String: String]

enum HTTPRequestParameter {
    case query([String: String])
    case body(Encodable)
}
