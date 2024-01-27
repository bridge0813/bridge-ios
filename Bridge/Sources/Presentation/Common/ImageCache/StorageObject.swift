//
//  StorageObject.swift
//  Bridge
//
//  Created by 엄지호 on 1/28/24.
//

import Foundation

// 메모리와 디스크에 저장할 객체
final class StorageObject {
    let imageData: Data
    private let expiration: StorageExpiration
    var estimatedExpiration: Date  // 만료 날짜
    
    init(imageData: Data, expiration: StorageExpiration) {
        self.imageData = imageData
        self.expiration = expiration
        self.estimatedExpiration = expiration.estimatedExpirationSince()
    }
    
    var isExpired: Bool {
        return estimatedExpiration.isPast
    }
}

extension Date {
    /// 현재 시간과 비교하여, 과거의 날짜(만료됨)인지 여부를 반환
    var isPast: Bool {
        return timeIntervalSince(Date()) <= 0
    }
}
