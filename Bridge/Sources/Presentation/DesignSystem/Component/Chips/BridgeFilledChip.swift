//
//  BridgeChipFillLabel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/10.
//

import UIKit

/// 디자인시스템 중 Chip의 Fill에 해당되는 라벨(short 버전 및 long 버전)
final class BridgeFilledChip: BaseLabel {
    
    private let type: ChipType
    
    init(backgroundColor: UIColor, type: ChipType) {
        self.type = type
        
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    override func configureAttributes() {
        textAlignment = .center
        textColor = BridgeColor.gray10
        font = BridgeFont.caption1.font
        clipsToBounds = true
        layer.cornerRadius = type.cornerRadius
    }
    
    /// drawText를 통해 텍스트를 그릴 때, 정해진 패딩값을 넣어주도록
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: type.padding))
    }
    
    /// 라벨의 사이즈도 패딩 값에 맞게 조정
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += type.padding.left + type.padding.right
        contentSize.height += type.padding.top + type.padding.bottom
        
        return contentSize
    }
}

extension BridgeFilledChip {
    enum ChipType {
        case short
        case long
        case custom(padding: UIEdgeInsets, radius: CGFloat)
        
        var padding: UIEdgeInsets {
            switch self {
            case .short: return UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
            case .long: return UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
            case .custom(let padding, _): return padding
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .short: return 11
            case .long: return 13
            case .custom(_, let radius): return radius
            }
        }
    }
}
