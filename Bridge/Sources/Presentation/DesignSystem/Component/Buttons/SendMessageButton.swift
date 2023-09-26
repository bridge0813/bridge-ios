//
//  SendMessageButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/25.
//

import UIKit

final class SendMessageButton: BaseButton {
    override func configureAttributes() {
        let buttonImage = UIImage(named: "send.fill")?
            .resize(to: CGSize(width: 26, height: 26))
            .withRenderingMode(.alwaysTemplate)
        
        var configuration = UIButton.Configuration.filled()
        configuration.image = buttonImage
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = BridgeColor.gray9
        
        self.configuration = configuration
        self.changesSelectionAsPrimaryAction = true
        self.configurationUpdateHandler = { button in
            let tintColor: UIColor = button.state == .selected ? .white : BridgeColor.gray3
            let backgroundColor: UIColor = button.state == .selected ? BridgeColor.primary1 : BridgeColor.gray9
            var updatedConfiguration = button.configuration
            updatedConfiguration?.baseForegroundColor = tintColor
            updatedConfiguration?.baseBackgroundColor = backgroundColor
            button.configuration = updatedConfiguration
        }
    }
}
