//
//  CancelButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/25.
//

import UIKit

final class CancelButton: BaseButton {
    override func configureButton(with title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .lightGray.withAlphaComponent(0.9)
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .boldSystemFont(ofSize: 16)
        titleContainer.foregroundColor = .white
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
    }
}
