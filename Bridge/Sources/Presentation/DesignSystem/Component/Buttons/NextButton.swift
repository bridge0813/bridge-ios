//
//  NextButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/28.
//

import UIKit

final class NextButton: BaseButton {
    override func configureAttributes() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = BridgeColor.gray4
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.button1.font
        titleContainer.foregroundColor = BridgeColor.gray10
        configuration.attributedTitle = AttributedString("다음", attributes: titleContainer)
        
        self.layer.cornerRadius = 4
        self.configuration = configuration
        self.changesSelectionAsPrimaryAction = true
        self.configurationUpdateHandler = { button in
            let backgroundColor: UIColor = button.state == .selected ? BridgeColor.primary1 : BridgeColor.gray4
    
            var updatedConfiguration = button.configuration
            updatedConfiguration?.baseBackgroundColor = backgroundColor
            button.configuration = updatedConfiguration
        }
    }
}
