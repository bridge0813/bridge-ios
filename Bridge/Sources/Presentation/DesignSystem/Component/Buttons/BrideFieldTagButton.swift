//
//  BrideFieldTagButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/14.
//

import UIKit

// 팀원의 분야를 선택할 때 사용되는 버튼 ex) iOS, 프론트엔드, UI/UX 등
final class BrideFieldTagButton: BaseButton {
    
    private var title: String
    
    init(_ title: String) {
        self.title = title
        super.init(frame: .zero)
    }
    
    override func configureAttributes() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = BridgeColor.gray9
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.tag1.font
        titleContainer.foregroundColor = BridgeColor.gray3
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        layer.borderColor = BridgeColor.primary1.cgColor
        layer.cornerRadius = 8
        
        self.configuration = configuration
        changesSelectionAsPrimaryAction = true
        configurationUpdateHandler = { button in
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
