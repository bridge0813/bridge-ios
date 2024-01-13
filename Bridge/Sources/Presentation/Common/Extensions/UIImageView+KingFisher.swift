//
//  UIImageView+KingFisher.swift
//  Bridge
//
//  Created by 엄지호 on 1/13/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String, width: CGFloat, height: CGFloat) {
        let url = URL(string: urlString)
        
        // 다운샘플링 후 Readius 적용
        let processor = DownsamplingImageProcessor(size: CGSize(width: width, height: height))
        |> RoundCornerImageProcessor(cornerRadius: self.layer.cornerRadius)
        
        // 이미지 처리 옵션
        let options: KingfisherOptionsInfo = [
            .scaleFactor(UIScreen.main.scale),
            .processor(processor),
            .transition(.fade(0.4)),
            .cacheOriginalImage
        ]
        
        // 다운로드 작업이 진행중일 때, 이미지 뷰에 인디케이터 설정.
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, options: options) { result in
            switch result {
            case .success:
                print("성공")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
