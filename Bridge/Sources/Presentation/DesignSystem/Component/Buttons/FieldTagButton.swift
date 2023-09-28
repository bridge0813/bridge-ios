//
//  FieldTagButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/14.
//

import UIKit

final class FieldTagButton: BaseButton {
    
    init(with title: String) {
        super.init(frame: .zero)
        
        configureAttributes(with: title)
    }
    
    override func configureAttributes(with title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = BridgeColor.gray9
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.tag1.font
        titleContainer.foregroundColor = BridgeColor.gray3
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.cornerRadius = 8
        
        self.configuration = configuration
        self.changesSelectionAsPrimaryAction = true
        self.configurationUpdateHandler = { button in
            let textColor: UIColor = button.state == .selected ? BridgeColor.primary1 : BridgeColor.gray3
            let backgroundColor: UIColor = button.state == .selected ? BridgeColor.gray10 : BridgeColor.gray9
            let borderWidth: CGFloat = button.state == .selected ? 1 : 0
            
            button.layer.borderWidth = borderWidth
            
            let attributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
                var updatedAttributes = attributes
                updatedAttributes.foregroundColor = textColor
                return updatedAttributes
            }
            
            var updatedConfiguration = button.configuration
            updatedConfiguration?.baseBackgroundColor = backgroundColor
            updatedConfiguration?.titleTextAttributesTransformer = attributesTransformer
            
            button.configuration = updatedConfiguration
        }
    }
}
