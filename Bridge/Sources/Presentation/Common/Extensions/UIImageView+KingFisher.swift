//
//  UIImageView+KingFisher.swift
//  Bridge
//
//  Created by 엄지호 on 1/13/24.
//

import UIKit

extension UIImageView {
    /// URL을 가지고 이미지를 다운로드하여 적용하는 메서드
    /// 캐시, 디스크 메모리에 해당 이미지가 존재한다면 가져와서 적용
    /// - Parameter urlString: 이미지가 위치한 URL의 문자열 형태
    /// - Parameter size: 다운샘플링 할 이미지의 크기
    /// - Parameter placeholderImage: 이미지 적용에 실패했을 경우, 적용되는 플레이스홀더 이미지
    func setImage(
        from urlString: URLString?,
        size: CGSize,
        placeholderImage: UIImage? = UIImage(named: "profile.small")
    ) {
        // 유효하지 않은 URL인 경우 플레이스홀더를 이미지로 설정
        guard let urlString, let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        
        ImageCache.shared.load(url: url, withOption: .downsampling(size: size)) { [weak self] image in
            guard let self else { return }
            
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
                // 이미지가 없으면 플레이스홀더 적용, 있으면 해당 이미지 적용
                self.image = image == nil ? placeholderImage : image
            }
        }
    }
}
