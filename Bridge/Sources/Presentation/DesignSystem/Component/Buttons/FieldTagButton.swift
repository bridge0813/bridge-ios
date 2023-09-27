//
//  FieldTagButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/14.
//

import UIKit

final class FieldTagButton: BaseButton {
    
    init(_ title: String) {
        super.init(frame: .zero)
        
        configureAttributes(with: title)
    }
    
    override func configureAttributes(with title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .lightGray.withAlphaComponent(0.1)
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .boldSystemFont(ofSize: 13)
        titleContainer.foregroundColor = .gray
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.layer.borderColor = UIColor.orange.cgColor
        
        self.configuration = configuration
        self.changesSelectionAsPrimaryAction = true
        
        self.configurationUpdateHandler = { button in
            let textColor: UIColor = button.state == .selected ? .orange : .gray
            let backgroundColor: UIColor = button.state == .selected ? .white : .lightGray.withAlphaComponent(0.1)
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
