//
//  BridgeChipLineLabel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/10.
//

import UIKit

/// 디자인시스템 중 Chip의 Line에 해당되는 라벨(D-day를 나타낼 때 사용됨)
final class BridgeChipLineLabel: BaseLabel {
    
    private let padding = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    
    override func configureAttributes() {
        textAlignment = .center
        textColor = BridgeColor.primary1
        font = BridgeFont.caption1.font
        clipsToBounds = true
        layer.cornerRadius = 11
        layer.borderColor = BridgeColor.primary1.cgColor
        layer.borderWidth = 1
    }
    
    /// drawText를 통해 텍스트를 그릴 때, 정해진 패딩값을 넣어주도록
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    /// 라벨의 사이즈도 패딩 값에 맞게 조정
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += padding.left + padding.right
        contentSize.height += padding.top + padding.bottom
        
        return contentSize
    }
}
