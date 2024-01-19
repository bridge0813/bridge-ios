//
//  ImageCache.swift
//  Bridge
//
//  Created by 엄지호 on 1/19/24.
//

import UIKit
import RxSwift

final class ImageCache {
    // MARK: - Property
    static let shared = ImageCache()
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    
    // MARK: - Init
    private init() { createBridgeDirectory() }
    
    func load(url: URL, completion: @escaping (UIImage?) -> Void) {
        // 1. 캐시 메모리에서 이미지 찾기
        if let cachedImage = getImageFromMemory(forKey: url as NSURL) {
            completion(cachedImage)
            return
        }
        
        // 2. 디스크 메모리에서 이미지 찾기
        if let diskImage = getImageFromDisk(with: url.lastPathComponent) {
            saveImageToMemory(diskImage, forKey: url as NSURL)
            completion(diskImage)
            return
        }
        
        // 3. 이미지 다운로드
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }
            
            if let error {
                completion(nil)
                return
            }
            
            guard let data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self.saveImageToMemory(image, forKey: url as NSURL)
            self.saveImageToDisk(image, identifier: url.lastPathComponent)
            
            DispatchQueue.main.async {
                completion(image)
            }
            
        }.resume()
    }
}

// MARK: - Cache, 이미지 Find & Save
extension ImageCache {
    /// 캐시 메모리에서 이미지를 가져오는 메서드
    private func getImageFromMemory(forKey key: NSURL) -> UIImage? {
        return cachedImages.object(forKey: key)
    }
    
    /// 메모리에 이미지를 캐싱하는 메서드
    private func saveImageToMemory(_ image: UIImage, forKey key: NSURL) {
        cachedImages.setObject(image, forKey: key)
    }
}

// MARK: - Disk, 이미지 Find & Save
extension ImageCache {
    /// 이미지 디스크 캐싱
    private func saveImageToDisk(_ image: UIImage, identifier: String) {
        guard let data = image.jpegData(compressionQuality: 1) else {
            print("이미지 변환 실패")
            return
        }
        
        guard let resultURL = bridgeDirectoryURL?.appendingPathComponent(identifier) else {
            print("저장할 위치 URL 생성 실패")
            return
        }
        
        do {
            try data.write(to: resultURL)
            print("디스크 캐싱 성공")
            
        } catch {
            print("디스크 캐싱 실패 \(error.localizedDescription)")
        }
    }
    
    /// 디스크에서 이미지를 가져오는 메서드
    private func getImageFromDisk(with identifier: String) -> UIImage? {
        guard let resultURL = bridgeDirectoryURL?.appendingPathComponent(identifier) else {
            print("저장할 위치 URL 생성 실패")
            return nil
        }
        
        guard FileManager.default.fileExists(atPath: resultURL.path) else {
            print("이미지 존재하지 않음")
            return nil
        }
        
        return UIImage(contentsOfFile: resultURL.path)
    }
}

// MARK: - Disk, 이미지를 저장 할 디렉토리 생성
extension ImageCache {
    /// 이미지가 저장되어 있는 디렉토리 URL
    private var bridgeDirectoryURL: URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?
            .appendingPathComponent("Bridge")
    }
    
    /// 이미지를 저장할 디렉토리 생성(존재하지 않을 경우)
    private func createBridgeDirectory() {
        guard let bridgeDirectoryURL else { return }
        
        if !FileManager.default.fileExists(atPath: bridgeDirectoryURL.path) {
            do {
                try FileManager.default.createDirectory(
                    atPath: bridgeDirectoryURL.path, withIntermediateDirectories: true
                )
                print("Bridge 디렉토리 생성 성공 \(bridgeDirectoryURL.path)")
                
            } catch {
                print("Bridge 디렉토리 생성 실패: \(error)")
            }
        }
    }
}
