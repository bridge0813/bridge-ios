//
//  OutlinedTagButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit

// Borderline이 존재하는 Tag 버튼("Swift", "Java" 등 기술스택에 관한 태그를 담당)
final class OutlinedTagButton: BaseButton {
    
    private var title: String
    
    init(_ title: String) {
        self.title = title
        super.init(frame: .zero)
    }
    
    override func configureAttributes() {
        let buttonImage = UIImage(named: "delete")?
            .resize(to: CGSize(width: 18, height: 18))
            .withRenderingMode(.alwaysTemplate)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = BridgeColor.gray10
        configuration.baseForegroundColor = BridgeColor.primary1
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        configuration.image = buttonImage
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 2
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.tag1.font
        titleContainer.foregroundColor = BridgeColor.primary1
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
        layer.borderColor = BridgeColor.primary1.cgColor
        layer.borderWidth = 1.5
        layer.cornerRadius = 4
    }
}
