//
//  BridgeBlockButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/28.
//

import UIKit

// 그만두기, 보러가기, 지원하기, 프로젝트 상세 등 기본적으로 사용될 수 있는 버튼
final class BridgeButton: BaseButton {
    
    private var title: String
    private var style: BridgeButtonStyle

    init(_ title: String, style: BridgeButtonStyle) {
        self.title = title
        self.style = style
        
        super.init(frame: .zero)
    }
    
    override func configureAttributes() {
        setTitle(title, for: .normal)
        setTitleColor(BridgeColor.gray10, for: .normal)
        titleLabel?.font = style.font
        backgroundColor = style.backgroundColor
        layer.cornerRadius = 4
    }
}

enum BridgeButtonStyle {
    case confirm
    case cancel
    case apply
    case detail
    
    var backgroundColor: UIColor {
        switch self {
        case .confirm, .apply, .detail:
            return BridgeColor.primary1
            
        case .cancel:
            return BridgeColor.gray4
        }
    }
    
    var font: UIFont {
        switch self {
        case .confirm, .cancel, .detail:
            return BridgeFont.button2.font
            
        case .apply:
            return BridgeFont.subtitle2.font
        }
    }
}