//
//  MainFieldCategoryAnchorButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/12.
//

import UIKit

final class MainFieldCategoryAnchorButton: BaseButton {
    override func configureAttributes() {
        let buttonImage = UIImage(named: "chevron.down")?.resize(to: CGSize(width: 20, height: 20))

        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .clear
        configuration.baseBackgroundColor = .clear
        
        configuration.image = buttonImage
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 3
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.subtitle1.font
        titleContainer.foregroundColor = BridgeColor.gray1
        configuration.attributedTitle = AttributedString("UI/UX", attributes: titleContainer)
        
        self.configuration = configuration
        contentHorizontalAlignment = .leading
    }
}

extension MainFieldCategoryAnchorButton {
    func updateTitle(_ newTitle: String) {
        var updatedConfiguration = configuration
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.subtitle1.font
        titleContainer.foregroundColor = BridgeColor.gray1
        updatedConfiguration?.attributedTitle = AttributedString(newTitle, attributes: titleContainer)
        
        configuration = updatedConfiguration
    }
}
