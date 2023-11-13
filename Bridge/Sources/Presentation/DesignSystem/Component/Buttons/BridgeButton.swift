//
//  BridgeButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/28.
//

import UIKit

// 그만두기, 보러가기, 지원하기, 프로젝트 상세 등 기본적으로 사용될 수 있는 버튼
final class BridgeButton: BaseButton {
    
    private let title: String
    private let titleFont: UIFont
    
    override var isEnabled: Bool {
        didSet { updateBackgroundColor() }
    }
    
    init(title: String, font: UIFont, backgroundColor: UIColor) {
        self.title = title
        self.titleFont = font
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    override func configureAttributes() {
        setTitle(title, for: .normal)
        setTitleColor(BridgeColor.gray10, for: .normal)
        titleLabel?.font = titleFont
        layer.cornerRadius = 4
    }

    private func updateBackgroundColor() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.backgroundColor = self.isEnabled ? BridgeColor.primary1 : BridgeColor.gray04
        }
    }
}
