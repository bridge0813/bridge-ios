//
//  StorageExpiration.swift
//  Bridge
//
//  Created by 엄지호 on 1/28/24.
//

import Foundation

/// 캐시된 데이터의 만료를 정의
enum StorageExpiration {
    case seconds(TimeInterval)
    case days(Int)
    
    func estimatedExpirationSince() -> Date {
        switch self {
        case .seconds(let seconds):
            return Date().addingTimeInterval(seconds)
            
        case .days(let days):
            // 하루를 초 단위로 환산 * 일 수
            let duration = TimeInterval(86_400) * TimeInterval(days)
            return Date().addingTimeInterval(duration)
        }
    }
}
