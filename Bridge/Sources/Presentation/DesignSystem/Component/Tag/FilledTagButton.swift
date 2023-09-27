//
//  FilledTagButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit

// 디자인시스템에서 Tag 영역에 있는 버튼(Fill 버전)
// 문제: 수 많은 버튼을 사용할 때, 텍스트 갯수에 따라 width가 다른데 다 일일히 정해줄 순 없음.
final class FilledTagButton: BaseButton {
    
    init(_ title: String) {
        super.init(frame: .zero)
        
        configureAttributes(with: title)
    }
    
    override func configureAttributes(with title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = BridgeColor.gray10
        
        // Horizontal padding = 20, Vertical padding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.tag1.font
        titleContainer.foregroundColor = BridgeColor.gray2
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
}
