//
//  SetRecruitNumberButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/24.
//

import UIKit

/// 모집인원 설정이나, 날짜 설정에서 사용되는 버튼으로, 클릭하여 무언가를 설정하고, 설정된 결과물을 버튼의 타이틀로 표시.
final class BridgeSetDisplayButton: BaseButton {
    
    private let placeholderText: String
    
    init(_ placeholderText: String) {
        self.placeholderText = placeholderText
        super.init(frame: .zero)
    }
    
    override func configureAttributes() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 16, bottom: 17, trailing: 16)
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.body2.font
        titleContainer.foregroundColor = BridgeColor.gray04
        configuration.attributedTitle = AttributedString(placeholderText, attributes: titleContainer)
        
        self.configuration = configuration
        layer.borderColor = BridgeColor.gray06.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        contentHorizontalAlignment = .leading
    }
    
    func updateTitle(_ title: String) {
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.body2.font
        titleContainer.foregroundColor = BridgeColor.gray02
        configuration?.attributedTitle = AttributedString(title, attributes: titleContainer)
    }
}
