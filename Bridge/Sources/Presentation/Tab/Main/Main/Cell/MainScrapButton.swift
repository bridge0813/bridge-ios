//
//  MainScrapButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/18.
//

import UIKit

final class MainScrapButton: BaseButton {
    override func configureAttributes() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = BridgeColor.gray6

        self.configuration = configuration
        changesSelectionAsPrimaryAction = true
        configurationUpdateHandler = { button in
            let tintColor: UIColor = button.state == .selected ? BridgeColor.primary1 : BridgeColor.gray6
            let imageName: String = button.state == .selected ? "bookmark.fill" : "bookmark"
            
            let buttonImage = UIImage(named: imageName)?
                .resize(to: CGSize(width: 24, height: 24))
                .withRenderingMode(.alwaysTemplate)
            
            var updatedConfiguration = button.configuration
            updatedConfiguration?.image = buttonImage
            updatedConfiguration?.baseForegroundColor = tintColor
            button.configuration = updatedConfiguration
        }
    }
}
