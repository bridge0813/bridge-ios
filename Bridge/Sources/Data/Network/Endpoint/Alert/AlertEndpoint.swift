//
//  AlertEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 12/22/23.
//

import Foundation

enum AlertEndpoint {
    case fetchAlerts
    case removeAlert(id: String)
    case removeAllAlerts
}

extension AlertEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchAlerts:
            return "/alarms"
            
        case .removeAlert:
            return "/alarm"
            
        case .removeAllAlerts:
            return "/alarms"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .fetchAlerts:
            return nil
            
        case .removeAlert(let id):
            return ["alarmId": id]
            
        case .removeAllAlerts:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchAlerts:
            return .get
            
        case .removeAlert:
            return .delete
            
        case .removeAllAlerts:
            return .delete
        }
    }
    
    var body: Encodable? { nil }
}
