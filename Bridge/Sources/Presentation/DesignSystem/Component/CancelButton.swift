//
//  CancelButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/25.
//

import UIKit

final class CancelButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)
        configureButton(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton(_ title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .lightGray.withAlphaComponent(0.9)
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .boldSystemFont(ofSize: 16)
        titleContainer.foregroundColor = .white
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
    }
}
