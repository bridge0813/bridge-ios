//
//  MenuButton.swift
//  Bridge
//
//  Created by 엄지호 on 12/8/23.
//

import UIKit

/// BridgeActionSheet에서 사용되는 버튼.
final class BridgeActionSheetButton: BaseButton {
    
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
            UIImage(named: "checkmark")?.resize(to: CGSize(width: 15, height: 15)) : nil
            
            let contentInsets: NSDirectionalEdgeInsets = button.state == .selected ?
                .init(top: 0, leading: 22, bottom: 0, trailing: 0) :
                .init()
            
            var updatedConfiguration = button.configuration
            updatedConfiguration?.image = buttonImage
            updatedConfiguration?.imagePlacement = .trailing
            updatedConfiguration?.imagePadding = 7
            updatedConfiguration?.contentInsets = contentInsets
            
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
