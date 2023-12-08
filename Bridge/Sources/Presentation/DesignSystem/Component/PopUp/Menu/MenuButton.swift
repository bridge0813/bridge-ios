//
//  MenuButton.swift
//  Bridge
//
//  Created by 엄지호 on 12/8/23.
//

import UIKit

/// Menu 팝업 뷰에서 사용되는 버튼.
final class MenuButton: BaseButton {
    
    var title = "" {
        didSet {
            updateTitle(title)
        }
    }
    
    override func configureAttributes() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = .clear
        
        self.configuration = configuration
        configurationUpdateHandler = { button in
            let buttonImage = button.state == .selected ?
            UIImage(named: "checkmark")?.resize(to: CGSize(width: 13, height: 13)) : nil
            
            var updatedConfiguration = button.configuration
            updatedConfiguration?.image = buttonImage
            updatedConfiguration?.imagePlacement = .trailing
            updatedConfiguration?.imagePadding = 2
            
            button.configuration = updatedConfiguration
        }
    }
    
    private func updateTitle(_ newTitle: String) {
        var updatedConfiguration = configuration
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.subtitle3.font
        titleContainer.foregroundColor = BridgeColor.gray02
        updatedConfiguration?.attributedTitle = AttributedString(newTitle, attributes: titleContainer)
        
        configuration = updatedConfiguration
    }
}
