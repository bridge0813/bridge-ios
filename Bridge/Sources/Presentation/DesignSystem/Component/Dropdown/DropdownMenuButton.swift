//
//  DropdownMenuButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit

final class DropdownMenuButton: BaseButton {
    override func configureButton(with title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .white
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .boldSystemFont(ofSize: 14)
        titleContainer.foregroundColor = .black
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
        self.contentHorizontalAlignment = .left
        self.changesSelectionAsPrimaryAction = true
        self.configurationUpdateHandler = { button in
            let backgroundColor: UIColor = button.state == .selected ? BridgeColor.primary3 : .white

            var updatedConfiguration = button.configuration
            updatedConfiguration?.baseBackgroundColor = backgroundColor
            button.configuration = updatedConfiguration
        }
    }
}
