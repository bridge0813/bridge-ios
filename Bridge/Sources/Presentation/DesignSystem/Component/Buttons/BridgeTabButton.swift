//
//  ManagementTapButton.swift
//  Bridge
//
//  Created by 엄지호 on 12/6/23.
//

import UIKit

/// 전환용 탭 버튼(관리 탭, 분야 및 스택 선택 등에서 사용)
final class BridgeTabButton: BaseButton {
    
    private var title: String
    private var titleFont: UIFont
    
    init(title: String, titleFont: UIFont) {
        self.title = title
        self.titleFont = titleFont
        super.init(frame: .zero)
    }
    
    override func configureAttributes() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        
        var titleContainer = AttributeContainer()
        titleContainer.font = titleFont
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
