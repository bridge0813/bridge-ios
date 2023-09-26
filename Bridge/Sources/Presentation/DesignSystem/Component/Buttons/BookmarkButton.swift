//
//  BookmarkButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/25.
//

import UIKit

final class BookmarkButton: BaseButton {
    override func configureAttributes() {
        let buttonImage = UIImage(named: "bookmark.fill")?.resize(to: CGSize(width: 22, height: 22)).withRenderingMode(.alwaysTemplate)
        
        var configuration = UIButton.Configuration.filled()
        configuration.image = buttonImage
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .lightGray
        
        self.configuration = configuration
        self.changesSelectionAsPrimaryAction = true
        self.configurationUpdateHandler = { button in
            let tintColor: UIColor = button.state == .selected ? BridgeColor.primary1 : .white
            let backgroundColor: UIColor = button.state == .selected ? BridgeColor.primary3 : BridgeColor.gray4

            var updatedConfiguration = button.configuration
            updatedConfiguration?.baseForegroundColor = tintColor
            updatedConfiguration?.baseBackgroundColor = backgroundColor
            button.configuration = updatedConfiguration
        }
    }
}
