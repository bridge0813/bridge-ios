//
//  BridgeButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/28.
//

import UIKit

// 그만두기, 보러가기, 지원하기, 프로젝트 상세 등 기본적으로 사용될 수 있는 버튼
final class BridgeButton: BaseButton {
    
    private var title: String
    private var titleFont: UIFont

    init(_ title: String, titleFont: UIFont, backgroundColor: UIColor) {
        self.title = title
        self.titleFont = titleFont
        
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    override func configureAttributes() {
        setTitle(title, for: .normal)
        setTitleColor(BridgeColor.gray10, for: .normal)
        titleLabel?.font = titleFont
        layer.cornerRadius = 4
    }

    /// 버튼의 활성화/비활성화 상태를 변경하는 메서드
    func updateButtonState(isActive: Bool) {
        backgroundColor = isActive ? BridgeColor.primary1 : BridgeColor.gray4
        isEnabled = isActive
    }
}
