//
//  PlainTextMenuButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit

final class PlainTextMenuButton: BaseButton {
    override func configureButton(with title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .white
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .boldSystemFont(ofSize: 14)
        titleContainer.foregroundColor = .gray
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
        self.contentHorizontalAlignment = .left
    }
}
