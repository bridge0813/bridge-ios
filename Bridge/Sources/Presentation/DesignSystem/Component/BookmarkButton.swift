//
//  BookmarkButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/25.
//

import UIKit

final class BookmarkButton: UIButton {

    init() {
        super.init(frame: .zero)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .heavy, scale: .default)
        let buttonImage = UIImage(systemName: "bookmark.fill", withConfiguration: imageConfig)
        
        var configuration = UIButton.Configuration.filled()
        configuration.image = buttonImage
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .lightGray
        
        self.configuration = configuration
        self.changesSelectionAsPrimaryAction = true
        self.configurationUpdateHandler = { button in
            let tintColor: UIColor = button.state == .selected ? .orange : .white
            let backgroundColor: UIColor = button.state == .selected ? .orange.withAlphaComponent(0.1) : .lightGray

            var updatedConfiguration = button.configuration
            updatedConfiguration?.baseForegroundColor = tintColor
            updatedConfiguration?.baseBackgroundColor = backgroundColor
            button.configuration = updatedConfiguration
        }
    }

}
