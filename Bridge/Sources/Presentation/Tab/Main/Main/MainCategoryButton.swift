//
//  MainCategoryButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/12.
//

import UIKit

/// '신규', '인기', '마감임박', '출시예정' 카테고리를 나타내는 버튼
final class MainCategoryButton: BaseButton {
    
    private var title: String
    private var normalImageName: String
    private var selectedImageName: String
    
    init(title: String, normalImageName: String, selectedImageName: String) {
        self.title = title
        self.normalImageName = normalImageName
        self.selectedImageName = selectedImageName
        super.init(frame: .zero)
    }
    
    override func configureAttributes() {
        let buttonImage = UIImage(named: normalImageName)?.resize(to: CGSize(width: 46, height: 46))
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = .clear
        
        configuration.image = buttonImage
        configuration.imagePlacement = .top
        configuration.imagePadding = 7.8
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.body3.font
        titleContainer.foregroundColor = BridgeColor.gray3
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
        configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            
            let textColor: UIColor = button.state == .selected ? BridgeColor.primary1 : BridgeColor.gray3
            let imageName: String = button.state == .selected ? self.selectedImageName : self.normalImageName
            
            let buttonImage = UIImage(named: imageName)?.resize(to: CGSize(width: 46, height: 46))
            
            let attributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
                var updatedAttributes = attributes
                updatedAttributes.foregroundColor = textColor
                return updatedAttributes
            }
            
            var updatedConfiguration = button.configuration
            updatedConfiguration?.titleTextAttributesTransformer = attributesTransformer
            updatedConfiguration?.image = buttonImage
            button.configuration = updatedConfiguration
        }
    }
}
