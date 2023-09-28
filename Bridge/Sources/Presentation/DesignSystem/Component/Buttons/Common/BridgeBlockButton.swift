//
//  BridgeBlockButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/28.
//

import UIKit

final class BridgeBlockButton: BaseButton {

    init(with title: String, style: ButtonStyle) {
        super.init(frame: .zero)
        
        configureAttributes(with: title, style: style)
    }
    
    func configureAttributes(with title: String, style: ButtonStyle) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = style.backgroundColor
        
        var titleContainer = AttributeContainer()
        titleContainer.font = style.font
        titleContainer.foregroundColor = BridgeColor.gray10
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
        self.layer.cornerRadius = 4
    }
}
