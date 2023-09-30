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
    
    init(_ title: String) {
        self.title = title
        super.init(frame: .zero)
    }
    
    override func configureAttributes() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = BridgeColor.gray10
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.tag1.font
        titleContainer.foregroundColor = BridgeColor.gray2
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
        layer.cornerRadius = 8
    }
}
