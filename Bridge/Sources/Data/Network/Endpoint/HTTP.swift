//
//  HTTP.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST, PUT, PATCH
    case DELETE
}

typealias HTTPHeader = [String: String]

enum HTTPRequestParameter {
    case query([String: String])
    case body(Encodable)
}
