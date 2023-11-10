//
//  DropdownConstant.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/01.
//

import UIKit

// DropDown 라이브러리에서 사용하는 여러 상수들을 정의
enum DropdownConstant {
    enum DropdownItem {
        static let textColor = BridgeColor.gray01
        static let textFont = BridgeFont.button2.font
        static let selectedBackgroundColor = UIColor.clear
    }
    
    enum DropdownUI {
        static let borderWidth: CGFloat = 1
        static let borderColor = BridgeColor.gray8.cgColor
        static let cornerRadius: CGFloat = 8
        static let rowHeight: CGFloat = 42
        static let heightPadding: CGFloat = 20
        static let separatorColor = UIColor.clear
        
        // 그림자
        static let shadowColor = UIColor.black
        static let shadowOffset = CGSize(width: 0, height: 4)
        static let shadowOpacity: Float = 0.03
        static let shadowRadius: CGFloat = 4
    }
    
    enum Animation {
        static let duration = 0.2
        static let downScaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
}
