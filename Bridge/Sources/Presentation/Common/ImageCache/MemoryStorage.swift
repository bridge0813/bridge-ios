//
//  MemoryStorage.swift
//  Bridge
//
//  Created by 엄지호 on 1/28/24.
//

import Foundation

/// 캐시 메모리 저장소
final class MemoryStorage {
    // MARK: - Property
    private let storage: NSCache = {
        let cache = NSCache<NSURL, StorageObject>()
        // 캐시 최대 용량 설정
        let totalMemory = ProcessInfo.processInfo.physicalMemory
        let costLimit = totalMemory / 4
        cache.totalCostLimit = (costLimit > Int.max) ? Int.max : Int(costLimit)
        return cache
    }()
    
    // MARK: - Init
    init() { }
    
    // MARK: - CRUD
    /// 데이터 저장
    func store(_ imageData: Data, forKey key: NSURL) {
        let storageObject = StorageObject(imageData: imageData, expiration: .seconds(300))
        storage.setObject(storageObject, forKey: key)
    }
    
    /// 데이터 조회
    func value(forKey key: NSURL) -> Data? {
        return storage.object(forKey: key)?.imageData
    }
    
    /// 저장된 모든 데이터 제거
    func removeAll() {
        storage.removeAllObjects()
    }
}
