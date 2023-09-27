//
//  ConfirmButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/25.
//

import UIKit

final class ConfirmButton: BaseButton {

    init(with title: String) {
        super.init(frame: .zero)
        
        configureAttributes(with: title)
    }
    
    override func configureAttributes(with title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .orange.withAlphaComponent(0.9)
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .boldSystemFont(ofSize: 16)
        titleContainer.foregroundColor = .white
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
    }
}
