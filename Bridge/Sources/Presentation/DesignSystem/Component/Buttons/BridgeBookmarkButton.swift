//
//  BridgeBookmarkButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/25.
//

import UIKit

final class BridgeBookmarkButton: BaseButton {
    
    var isBookmarked: Bool = false {
        didSet {
            updateButtonState()
        }
    }
    
    override func configureAttributes() {
        let buttonImage = UIImage(named: "bookmark.fill")?
            .resize(to: CGSize(width: 24, height: 24))
            .withRenderingMode(.alwaysTemplate)
        
        var configuration = UIButton.Configuration.filled()
        configuration.image = buttonImage
        configuration.baseForegroundColor = BridgeColor.gray10
        configuration.baseBackgroundColor = BridgeColor.gray04
        
        layer.cornerRadius = 4
        self.configuration = configuration
    }

    private func updateButtonState() {
        let tintColor = isBookmarked ? BridgeColor.primary1 : BridgeColor.gray10
        let backgroundColor = isBookmarked ? BridgeColor.primary3 : BridgeColor.gray04

        var updatedConfiguration = configuration
        updatedConfiguration?.baseForegroundColor = tintColor
        updatedConfiguration?.baseBackgroundColor = backgroundColor
        configuration = updatedConfiguration
    }
}
