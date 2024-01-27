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
    
    private var keys = Set<NSURL>()  // 캐시에 저장된 객체들의 키를 추적하는 데 사용
    private let lock = NSLock()
    
    // MARK: - Init
    init() {
        // 240초 주기로 만료된 데이터를 제거
        Timer.scheduledTimer(withTimeInterval: 240, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.removeExpired()
        }
    }
    
    // MARK: - CRUD
    /// 데이터 저장
    func store(_ imageData: Data, forKey key: NSURL) {
        lock.lock()
        defer { lock.unlock() }
        
        let storageObject = StorageObject(imageData: imageData, expiration: .seconds(300))
        storage.setObject(storageObject, forKey: key)
        keys.insert(key)
    }
    
    /// 데이터 조회
    func value(forKey key: NSURL) -> Data? {
        return storage.object(forKey: key)?.imageData
    }
    
    /// 저장된 모든 데이터 제거
    func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        
        storage.removeAllObjects()
        keys.removeAll()
    }
    
    /// 만료된 데이터 제거
    private func removeExpired() {
        lock.lock()
        defer { lock.unlock() }
        
        for key in keys {
            guard let object = storage.object(forKey: key) else {
                keys.remove(key)
                continue
            }
            
            // 데이터가 만료된 경우 제거
            if object.isExpired {
                storage.removeObject(forKey: key)
                keys.remove(key)
            }
        }
    }
}
