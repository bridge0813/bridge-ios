//
//  DiskStorage.swift
//  Bridge
//
//  Created by 엄지호 on 1/28/24.
//

import Foundation

/// 디스크 저장소
final class DiskStorage {
    // MARK: - Property
    private let fileManager = FileManager.default
    private var directoryURL: URL?  // 이미지가 저장되어 있는 디렉토리 URL
    
    // MARK: - Init
    init() {
        createDirectory()
        directoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?
            .appendingPathComponent("Bridge")
    }
    
    // MARK: - CRUD
    /// 데이터 저장
    func store(_ imageData: Data, identifier: String) {
        guard let resultURL = directoryURL?.appendingPathComponent(identifier) else { return }
        let storageObject = StorageObject(imageData: imageData, expiration: .days(7))
        
        do {
            // 디스크 캐싱
            try storageObject.imageData.write(to: resultURL)
            
        } catch {
            print("데이터 저장 실패  \(error.localizedDescription)")
        }
    }
    
    /// 데이터 조회
    func value(with identifier: String) -> Data? {
        guard let resultURL = directoryURL?.appendingPathComponent(identifier) else {
            return nil
        }
        
        guard fileManager.fileExists(atPath: resultURL.path) else {
            return nil
        }
        
        return try? Data(contentsOf: resultURL)
    }
    
    /// 저장된 모든 데이터 제거
    func removeAll() {
        guard let directoryURL else { return }
        
        do {
            try fileManager.removeItem(at: directoryURL)
            print("저장된 디렉토리 제거 완료")
            
        } catch {
            print("저장된 디렉토리 제거 실패: \(error)")
        }
    }
    
    // MARK: - Helpers
    /// 데이터를 저장할 디렉토리 생성(존재하지 않을 경우)
    private func createDirectory() {
        guard let directoryURL else { return }
        
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(
                    atPath: directoryURL.path, withIntermediateDirectories: true
                )
                
            } catch {
                print("디렉토리 생성 실패: \(error)")
            }
        }
    }
}
