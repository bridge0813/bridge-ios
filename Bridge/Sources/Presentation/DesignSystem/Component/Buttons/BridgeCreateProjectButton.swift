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
    }
}

extension BridgeCreateProjectButton {
    // MARK: - Button Configuration
    func updateButtonConfiguration(for state: MainViewModel.CreateButtonDisplayState) {
        switch state {
        case .both:
            titleLabel?.alpha = 1
            updateButtonTitle(for: state)
            
        case .only:
            titleLabel?.alpha = 0
            contentHorizontalAlignment = .left
        }
    }
    
    // MARK: - Button Title
    func updateButtonTitle(for state: MainViewModel.CreateButtonDisplayState) {
        var updatedConfiguration = configuration
        
        switch state {
        case .both:
            var titleContainer = AttributeContainer()
            titleContainer.font = BridgeFont.subtitle1.font
            titleContainer.foregroundColor = BridgeColor.gray10
            updatedConfiguration?.attributedTitle = AttributedString("글쓰기", attributes: titleContainer)
            
        case .only:
            updatedConfiguration?.attributedTitle = nil
        }
        
        configuration = updatedConfiguration
    }
}
