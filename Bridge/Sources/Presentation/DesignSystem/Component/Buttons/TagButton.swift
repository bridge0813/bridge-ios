//
//  TagButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit

// 디자인시스템에서 Tag 영역에 있는 버튼(Fill 버전)
final class TagButton: BaseButton {
    
    private var title: String
    
    init(with title: String) {
        self.title = title
        super.init(frame: .zero)
    }
    
    override func configureAttributes() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = BridgeColor.gray10
        
        // Horizontal padding = 20, Vertical padding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.tag1.font
        titleContainer.foregroundColor = BridgeColor.gray2
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
        layer.cornerRadius = 8
    }
}
