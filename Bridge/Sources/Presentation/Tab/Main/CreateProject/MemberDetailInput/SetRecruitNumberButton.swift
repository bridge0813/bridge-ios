//
//  SetRecruitNumberButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/24.
//

import UIKit

/// 모집인원을 설정 및 표시하는 버튼
final class SetRecruitNumberButton: BaseButton {
    override func configureAttributes() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 17.5, leading: 16, bottom: 17.5, trailing: 16)
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.body2.font
        titleContainer.foregroundColor = BridgeColor.gray4
        configuration.attributedTitle = AttributedString("몇 명을 모집할까요?", attributes: titleContainer)
        
        self.configuration = configuration
        layer.borderColor = BridgeColor.gray6.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
    }
}
