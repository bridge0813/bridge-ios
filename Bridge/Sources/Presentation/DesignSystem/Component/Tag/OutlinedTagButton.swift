//
//  OutlinedTagButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit

final class OutlinedTagButton: BaseButton {
    override func configureButton(with title: String) {
        let buttonImage = UIImage(named: "delete")?
            .resize(to: CGSize(width: 18, height: 18))
            .withRenderingMode(.alwaysTemplate)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = BridgeColor.primary1
        
        configuration.image = buttonImage
        configuration.imagePlacement = .trailing
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.tag1.font
        titleContainer.foregroundColor = BridgeColor.primary1
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
        self.layer.borderColor = BridgeColor.primary1.cgColor
        self.layer.borderWidth = 1
    }
}
