//
//  MenuWithIconButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit

final class MenuWithIconButton: UIButton {
    
    init(title: String, imageName: String) {
        super.init(frame: .zero)
        
        configureAttributes(title: title, imageName: imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAttributes(title: String, imageName: String) {
        let buttonImage = UIImage(named: imageName)?
            .resize(to: CGSize(width: 22, height: 22))
            .withRenderingMode(.alwaysTemplate)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .gray
        configuration.image = buttonImage
        configuration.imagePlacement = .leading
        configuration.imagePadding = 5
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .boldSystemFont(ofSize: 15)
        titleContainer.foregroundColor = .gray
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
        self.contentHorizontalAlignment = .left
    }
}
