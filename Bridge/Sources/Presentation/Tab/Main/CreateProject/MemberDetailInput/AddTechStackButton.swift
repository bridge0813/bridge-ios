//
//  AddTechStackButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/24.
//

import UIKit

/// 팀원의 기술스택을 추가하는 버튼(스택이 추가되면, 타이틀이 수정으로 변경됨)
final class AddTechStackButton: BaseButton {
    
    var isAdded: Bool = false {
        willSet {
            if newValue { updateConfigurationForEdit() }
            else { updateConfigurationForAdd() }
        }
    }
    
    override func configureAttributes() {
        updateConfigurationForAdd()
    }
    
    // 추가된 스택이 없을 경우
    private func updateConfigurationForAdd() {
        let buttonImage = UIImage(named: "plus")?
            .resize(to: CGSize(width: 14, height: 14))
            .withRenderingMode(.alwaysTemplate)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = BridgeColor.primary1
        configuration.contentInsets = .zero
        
        configuration.image = buttonImage
        configuration.imagePlacement = .leading
        configuration.imagePadding = 1
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.body1.font
        titleContainer.foregroundColor = BridgeColor.primary1
        configuration.attributedTitle = AttributedString("추가", attributes: titleContainer)
        
        self.configuration = configuration
    }
    
    // 추가된 스택이 있을 경우
    private func updateConfigurationForEdit() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = BridgeColor.primary1
        configuration.contentInsets = .zero
    
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.body1.font
        titleContainer.foregroundColor = BridgeColor.primary1
        configuration.attributedTitle = AttributedString("수정", attributes: titleContainer)
        
        self.configuration = configuration
    }
}
