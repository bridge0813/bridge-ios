//
//  CreateProjectButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/29.
//

import UIKit

final class CreateProjectButton: BaseButton {
    override func configureAttributes() {
        let buttonImage = UIImage(named: "plus")?
            .resize(to: CGSize(width: 22, height: 22))
            .withRenderingMode(.alwaysTemplate)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = BridgeColor.primary1
        configuration.baseForegroundColor = BridgeColor.gray10
        
        configuration.image = buttonImage
        configuration.imagePlacement = .leading
        configuration.imagePadding = 5
        
        self.configuration = configuration
        configurationUpdateHandler = { button in
            var updatedConfiguration = button.configuration
            
            if button.isSelected {
                var titleContainer = AttributeContainer()
                titleContainer.font = BridgeFont.subtitle1.font
                titleContainer.foregroundColor = BridgeColor.gray10
                updatedConfiguration?.attributedTitle = AttributedString("글쓰기", attributes: titleContainer)
                
            } else {
                updatedConfiguration?.attributedTitle = nil  // 텍스트 제거
            }
            
            button.configuration = updatedConfiguration
        }
    }
}
