//
//  BridgeCreateProjectButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/29.
//

import UIKit

final class BridgeCreateProjectButton: BaseButton {
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
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.subtitle1.font
        titleContainer.foregroundColor = BridgeColor.gray10
        configuration.attributedTitle = AttributedString("글쓰기", attributes: titleContainer)
        
        self.configuration = configuration
        layer.cornerRadius = 24
    }
}

extension BridgeCreateProjectButton {
    // MARK: - Button Configuration
    func updateButtonConfiguration(for isExpanded: Bool) {
        if isExpanded {
            titleLabel?.alpha = 1
            updateButtonTitle(for: isExpanded)
        } else {
            titleLabel?.alpha = 0
            contentHorizontalAlignment = .left
        }
    }
    
    // MARK: - Button Title
    func updateButtonTitle(for isExpanded: Bool) {
        var updatedConfiguration = configuration
        
        if isExpanded {
            var titleContainer = AttributeContainer()
            titleContainer.font = BridgeFont.subtitle1.font
            titleContainer.foregroundColor = BridgeColor.gray10
            updatedConfiguration?.attributedTitle = AttributedString("글쓰기", attributes: titleContainer)
            
        } else {
            updatedConfiguration?.attributedTitle = nil
        }
        
        configuration = updatedConfiguration
    }
}
