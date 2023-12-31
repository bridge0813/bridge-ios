//
//  MainFieldCategoryAnchorButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/12.
//

import UIKit

/// 유저가 선택한 분야 카테고리를 보여주는 드롭다운의 트리거 버튼
final class FieldCategoryAnchorButton: BaseButton {
    
    var title = "" {
        didSet {
            updateTitle(title)
        }
    }
    
    var isImageVisible = true {
        didSet {
            if isImageVisible {
                configureWithImage()
                
            } else {
                configureWithoutImage()
            }
        }
    }
    
    override func configureAttributes() {
        configureWithImage()
    }
}

private extension FieldCategoryAnchorButton {
    func updateTitle(_ newTitle: String) {
        var updatedConfiguration = configuration
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.subtitle1.font
        titleContainer.foregroundColor = BridgeColor.gray01
        updatedConfiguration?.attributedTitle = AttributedString(newTitle, attributes: titleContainer)
        
        configuration = updatedConfiguration
    }
    
    func configureWithImage() {
        let buttonImage = UIImage(named: "chevron.down")?.resize(to: CGSize(width: 20, height: 20))

        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .clear
        configuration.baseBackgroundColor = .clear
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        configuration.image = buttonImage
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 3
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.subtitle1.font
        titleContainer.foregroundColor = BridgeColor.gray01
        configuration.attributedTitle = AttributedString("전체", attributes: titleContainer)
        
        self.configuration = configuration
        contentHorizontalAlignment = .leading
    }
    
    func configureWithoutImage() {
        configuration?.image = nil
    }
}
