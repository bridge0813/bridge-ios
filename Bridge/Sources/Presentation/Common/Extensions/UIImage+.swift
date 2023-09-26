//
//  UIImage+.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/25.
//

import UIKit

extension UIImage {
    func resize(to targetSize: CGSize) -> UIImage {
        // 원본 사이즈와 목표 사이즈의 가로, 세로 비율 계산
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let ratio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return resizedImage
    }
}
