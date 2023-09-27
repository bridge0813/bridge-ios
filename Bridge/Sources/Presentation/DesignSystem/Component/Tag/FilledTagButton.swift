//
//  FilledTagButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit

final class FilledTagButton: BaseButton {
    override func configureButton(with title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.tag1.font
        titleContainer.foregroundColor = BridgeFont.tag1.textColor
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
    }
}
