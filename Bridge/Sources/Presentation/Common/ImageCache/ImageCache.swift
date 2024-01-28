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
    func load(url: URL, withOption option: ImageProcessOption, completion: @escaping (UIImage?) -> Void) {
        // 이미지 처리 프로세서 생성
        let processor = createProcessor(for: option)
        
        // 1. 캐시 메모리에서 이미지 데이터 찾기
        if let cachedImageData = memoryStorage.value(forKey: url as NSURL) {
            DispatchQueue.global(qos: .userInitiated).async {
                let processedImage = processor.process(data: cachedImageData)
                
                DispatchQueue.main.async {
                    completion(processedImage)
                }
            }
            return
        }
        
        // 2. 디스크 메모리에서 이미지 데이터 찾기
        if let diskImageData = diskStorage.value(with: url.lastPathComponent) {
            DispatchQueue.global(qos: .userInitiated).async {
                let processedImage = processor.process(data: diskImageData)
                
                DispatchQueue.main.async {
                    completion(processedImage)
                }
            }
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
        
            let processedImage = processor.process(data: data)
            
            DispatchQueue.main.async {
                completion(processedImage)
            }
            
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

extension ImageCache {
    private func createProcessor(for option: ImageProcessOption) -> ImageProcessor {
        switch option {
        case .downsampling(let size):
            return DownsamplingImageProcessor(size: size)
        }
    }
}
