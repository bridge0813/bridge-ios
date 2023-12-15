//
//  ManagementTapButton.swift
//  Bridge
//
//  Created by 엄지호 on 12/6/23.
//

import UIKit

/// 관리 탭의 '지원', '모집' 에 사용되는 전환용 버튼
final class ManagementTabButton: BaseButton {
    
    private var title: String
    
    init(_ title: String) {
        self.title = title
        super.init(frame: .zero)
    }
    
    override func configureAttributes() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.headline1.font
        titleContainer.foregroundColor = BridgeColor.gray04
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
        configurationUpdateHandler = { button in
            let textColor: UIColor = button.state == .selected ? BridgeColor.gray01 : BridgeColor.gray04
            
            let attributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
                var updatedAttributes = attributes
                updatedAttributes.foregroundColor = textColor
                return updatedAttributes
            }
            
            var updatedConfiguration = button.configuration
            updatedConfiguration?.titleTextAttributesTransformer = attributesTransformer
            
            button.configuration = updatedConfiguration
        }
    }
}
