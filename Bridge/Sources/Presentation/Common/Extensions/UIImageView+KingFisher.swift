//
//  UIImageView+KingFisher.swift
//  Bridge
//
//  Created by 엄지호 on 1/13/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    /// URL을 가지고 이미지를 다운로드하여 적용하는 메서드
    /// 캐시, 디스크 메모리에 해당 이미지가 존재한다면 가져와서 적용
    /// - Parameter urlString: 이미지가 위치한 URL의 문자열 형태
    /// - Parameter size: 다운샘플링 할 이미지의 크기
    /// - Parameter placeholderImage: 이미지 적용에 실패했을 경우, 적용되는 플레이스홀더 이미지
    func setImage(
        with urlString: URLString?,
        size: CGSize,
        placeholderImage: UIImage? = UIImage(named: "profile.small")
    ) {
        guard let urlString else { return self.image = placeholderImage }
        let url = URL(string: urlString)
        
        // 다운샘플링 후 Readius 적용
        let processor = DownsamplingImageProcessor(size: size)
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
        self.kf.setImage(with: url, options: options) { [weak self] result in
            if case .failure(let error) = result {
                print(error.localizedDescription)
                self?.image = placeholderImage
            }
        }
    }
}
