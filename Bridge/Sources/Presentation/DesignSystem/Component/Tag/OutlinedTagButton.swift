//
//  OutlinedTagButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit

final class OutlinedTagButton: BaseButton {
    
    init(with title: String) {
        super.init(frame: .zero)
        
        configureAttributes(with: title)
    }
    
    override func configureAttributes(with title: String) {
        let buttonImage = UIImage(named: "delete")?
            .resize(to: CGSize(width: 18, height: 18))
            .withRenderingMode(.alwaysTemplate)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = BridgeColor.gray10
        configuration.baseForegroundColor = BridgeColor.primary1
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        configuration.image = buttonImage
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 2
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.tag1.font
        titleContainer.foregroundColor = BridgeColor.primary1
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
        self.layer.borderColor = BridgeColor.primary1.cgColor
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
}
