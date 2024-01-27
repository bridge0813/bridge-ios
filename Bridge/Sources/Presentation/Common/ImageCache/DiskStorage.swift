//
//  DiskStorage.swift
//  Bridge
//
//  Created by 엄지호 on 1/28/24.
//

import UIKit

/// 디스크 저장소
final class DiskStorage {
    // MARK: - Property
    private let fileManager = FileManager.default
    private var directoryURL: URL?  // 이미지가 저장되어 있는 디렉토리 URL
    
    // MARK: - Init
    init() {
        createDirectory()
        observeBackgroundNotification()
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
            
            // 속성 정의(만료날짜) 및 저장
            let attributes: [FileAttributeKey: Any] = [
                .modificationDate: storageObject.estimatedExpiration.fileAttributeDate
            ]
            try fileManager.setAttributes(attributes, ofItemAtPath: resultURL.path)
            
        } catch {
            print("데이터 및 속성 저장 실패  \(error.localizedDescription)")
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

// MARK: - 만료 데이터 제거
extension DiskStorage {
    /// 저장된 모든 파일의 URL을 가져오기
    private func getAllFileURLs() -> [URL]? {
        guard let directoryURL else { return nil }
        
        guard let directoryEnumerator = fileManager.enumerator(
            at: directoryURL,
            includingPropertiesForKeys: [.contentModificationDateKey],
            options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
        else { return nil }
        
        guard let urls = directoryEnumerator.allObjects as? [URL] else { return nil }
        return urls
    }
    
    /// 만료된 데이터 제거
    private func removeExpired() {
        guard let urls = getAllFileURLs() else { return }
        
        // 만료된 파일 조회
        let expiredFiles = urls.filter { url in
            do {
                let attributes = try fileManager.attributesOfItem(atPath: url.path)
                if let expirationDate = attributes[.modificationDate] as? Date {
                    return expirationDate.isPast
                }
            } catch {
                print("파일 속성 조회 실패: \(error.localizedDescription)")
            }
            return false
        }
        
        // 만료된 데이터 제거
        expiredFiles.forEach { url in
            do {
                try fileManager.removeItem(at: url)
                print("디렉토리 내 만료된 데이터 제거 성공: \(url)")
                
            } catch {
                print("디렉토리 내 만료된 데이터 제거 실패: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Notification
extension DiskStorage {
    private func observeBackgroundNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    @objc private func didEnterBackground() {
        removeExpired()
    }
}
