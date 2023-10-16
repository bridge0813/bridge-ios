//
//  PlaceholderView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/16.
//

import UIKit
import FlexLayout
import PinLayout

final class MainPlaceholderView: BaseCollectionReusableView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let holderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        label.textAlignment = .center
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray4
        label.numberOfLines = 2
        
        return label
    }()
    
    // MARK: - Layout
    private func configureLayouts(_ layout: HolderImageViewLayout) {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.alignItems(.center).define { flex in
            flex.addItem(holderImageView)
                .width(layout.width)
                .height(layout.height)
                .marginBottom(layout.marginBottom)
            flex.addItem(titleLabel).height(24).marginBottom(4)
            flex.addItem(subTitleLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all().marginTop(50)
        rootFlexContainer.flex.layout()
    }
}
// MARK: - Configuration
extension MainPlaceholderView {
    struct HolderImageViewLayout {
        let image: UIImage?
        let width: CGFloat
        let height: CGFloat
        let marginBottom: CGFloat
    }
    
    enum PlaceholderType {
        case comingSoon
        case nothing
        
        var imageViewLayout: HolderImageViewLayout {
            switch self {
            case .comingSoon:
                return HolderImageViewLayout(
                    image: UIImage(named: "placeholder.lock"),
                    width: 50,
                    height: 70,
                    marginBottom: 23.8
                )
                
            case .nothing:
                return HolderImageViewLayout(
                    image: UIImage(named: "placeholder.search"),
                    width: 100,
                    height: 100,
                    marginBottom: 3.8
                )
            }
        }
        
        var title: String {
            switch self {
            case .comingSoon:
                return "출시 예정이에요!"
                
            case .nothing:
                return "올라온 모집글이 없어요!"
            }
        }
        
        var subTitle: String {
            switch self {
            case .comingSoon:
                return "빠른 시일 내에 소개할 수 있도록 \n브릿지가 노력할게요:)"
                
            case .nothing:
                return "조금만 기달려 주세요."
            }
        }
    }
    
    func configureHolderView(_ type: PlaceholderType) {
        holderImageView.image = type.imageViewLayout.image
        titleLabel.text = type.title
        subTitleLabel.configureTextWithLineHeight(text: type.subTitle, lineHeight: 18, alignment: .center)
        
        configureLayouts(type.imageViewLayout)
    }
}
