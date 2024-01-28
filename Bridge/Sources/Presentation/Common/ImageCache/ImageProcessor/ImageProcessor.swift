//
//  ImageProcessor.swift
//  Bridge
//
//  Created by 엄지호 on 1/28/24.
//

import UIKit

enum ImageProcessOption {
    case downsampling(size: CGSize)
}

protocol ImageProcessor {
    func process(data: Data) -> UIImage?
}

struct DownsamplingImageProcessor: ImageProcessor {
    let size: CGSize
    
    init(size: CGSize) {
        self.size = size
    }
    
    func process(data: Data) -> UIImage? {
        // 이미지 소스를 생성할 때, 캐시를 사용할 지 여부를 결정
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        // CGImageSource 객체를 생성
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
            return nil
        }
        
        // 최대 픽셀 크기를 계산(이미지의 최종 크기를 결정)
        let maxDimensionInPixels = max(size.width, size.height) * UIScreen.main.scale
        
        // 다운샘플링에서 사용할 옵션
        let downsampleOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ]
        
        // 썸네일 생성
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(
            imageSource, 0, downsampleOptions as CFDictionary
        ) else { return nil }
        
        return UIImage(cgImage: downsampledImage, scale: UIScreen.main.scale, orientation: .up)
    }
}
