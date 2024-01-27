//
//  ImageCache.swift
//  Bridge
//
//  Created by 엄지호 on 1/28/24.
//

import UIKit

final class ImageCache {
    // MARK: - Property
    static let shared = ImageCache()
    private let memoryStorage = MemoryStorage()
    private let diskStorage = DiskStorage()
    
    // MARK: - Init
    private init() { }
    
    // MARK: - Load
    func load(url: URL, downsampleSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        // 1. 캐시 메모리에서 이미지 데이터 찾기
        if let cachedImageData = memoryStorage.value(forKey: url as NSURL) {
            // 이미지 작업 후 리턴
            return
        }
        
        // 2. 디스크 메모리에서 이미지 데이터 찾기
        if let diskImageData = diskStorage.value(with: url.lastPathComponent) {
            // 이미지 작업 후 리턴
            memoryStorage.store(diskImageData, forKey: url as NSURL)
            return
        }
        
        // 3. 이미지 다운로드
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self else { return }
            
            if let error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
        
            // 이미지 작업 후 리턴
            
            self.memoryStorage.store(data, forKey: url as NSURL)
            self.diskStorage.store(data, identifier: url.lastPathComponent)
            
        }
        .resume()
    }
    
    func clearMemoryCache() {
        memoryStorage.removeAll()
    }
    
    func clearDiskCache() {
        diskStorage.removeAll()
    }
}
