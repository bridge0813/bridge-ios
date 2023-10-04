//
//  BrideSendMessageButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/25.
//

import UIKit

final class BrideSendMessageButton: BaseButton {
    override func configureAttributes() {
        let buttonImage = UIImage(named: "send.fill")?
            .resize(to: CGSize(width: 16.21, height: 16.21))
            .withRenderingMode(.alwaysTemplate)
        
        var configuration = UIButton.Configuration.filled()
        configuration.image = buttonImage
        configuration.baseForegroundColor = BridgeColor.gray4
        configuration.baseBackgroundColor = BridgeColor.gray9
        
        layer.cornerRadius = 4
        self.configuration = configuration
        changesSelectionAsPrimaryAction = true
        configurationUpdateHandler = { button in
            let tintColor: UIColor = button.state == .selected ? BridgeColor.gray10 : BridgeColor.gray4
            let backgroundColor: UIColor = button.state == .selected ? BridgeColor.primary1 : BridgeColor.gray9
            
            var updatedConfiguration = button.configuration
            updatedConfiguration?.baseForegroundColor = tintColor
            updatedConfiguration?.baseBackgroundColor = backgroundColor
            button.configuration = updatedConfiguration
        }
    }
}
