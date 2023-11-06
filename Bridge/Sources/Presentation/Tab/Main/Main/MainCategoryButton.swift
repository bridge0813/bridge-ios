//
//  MainCategoryButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/12.
//

import UIKit

/// '신규', '인기', '마감임박', '출시예정' 카테고리를 나타내는 버튼
final class MainCategoryButton: BaseButton {
    
    private let style: ButtonStyle
    
    init(_ style: ButtonStyle) {
        self.style = style
        super.init(frame: .zero)
    }
    
    override func configureAttributes() {
        let buttonImage = UIImage(named: style.normalImageName)?.resize(to: CGSize(width: 46, height: 46))
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = .clear
        
        configuration.image = buttonImage
        configuration.imagePlacement = .top
        configuration.imagePadding = 8
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.body3.font
        titleContainer.foregroundColor = BridgeColor.gray03
        configuration.attributedTitle = AttributedString(style.title, attributes: titleContainer)
        
        self.configuration = configuration
        configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            
            let textColor: UIColor = button.state == .selected ? BridgeColor.primary1 : BridgeColor.gray03
            let imageName: String = button.state == .selected ? self.style.selectedImageName : self.style.normalImageName
            
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
        
        // 터치시 이미지를 살짝 커지게 함
        let touchDownAction = UIAction { [weak self] _ in
            self?.clickAnimation(scale: 1.1)
        }
        addAction(touchDownAction, for: .touchDown)

        // 터치가 끝나면 이미지를 원래 크기로 되돌림
        let touchUpAction = UIAction { [weak self] _ in
            self?.clickAnimation(scale: 1.0)
        }
        addAction(touchUpAction, for: .touchUpInside)
    }
    
    private func clickAnimation(scale: CGFloat) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.imageView?.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}

extension MainCategoryButton {
    enum ButtonStyle {
        case new
        case hot
        case deadlineApproach
        case comingSoon
        
        var title: String {
            switch self {
            case .new: return "신규"
            case .hot: return "인기"
            case .deadlineApproach: return "마감임박"
            case .comingSoon: return "출시예정"
            }
        }
        
        var normalImageName: String {
            switch self {
            case .new: return "main.sprouts.off"
            case .hot: return "main.trophy.off"
            case .deadlineApproach: return "main.bomb.off"
            case .comingSoon: return "main.mysterybox.off"
            }
        }
        
        var selectedImageName: String {
            switch self {
            case .new: return "main.sprouts.on"
            case .hot: return "main.trophy.on"
            case .deadlineApproach: return "main.bomb.on"
            case .comingSoon: return "main.mysterybox.on"
            }
        }
    }
}
