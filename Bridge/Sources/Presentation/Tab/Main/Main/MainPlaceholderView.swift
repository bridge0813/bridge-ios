//
//  PlaceholderView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/16.
//

import UIKit
import FlexLayout
import PinLayout

/// 모집글이 없거나, 카테고리 '출시예정' 에서 사용되는 FooterView
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
    private func configureLayouts(_ layout: HolderViewLayout) {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.alignItems(.center).define { flex in
            flex.addItem(holderImageView)
                .width(layout.imageViewWidth)
                .height(layout.imageViewHeight)
                .marginBottom(layout.marginBottom)
            flex.addItem(titleLabel).height(24).marginBottom(4)
            flex.addItem(subTitleLabel).width(180).height(layout.subLabelHeight)
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
    struct HolderViewLayout {
        let image: UIImage?
        let imageViewWidth: CGFloat
        let imageViewHeight: CGFloat
        let title: String
        let subTitle: String
        let subLabelHeight: CGFloat
        let marginBottom: CGFloat
    }
    
    enum PlaceholderType {
        case comingSoon
        case nothing
        
        var holderViewLayout: HolderViewLayout {
            switch self {
            case .comingSoon:
                return HolderViewLayout(
                    image: UIImage(named: "placeholder.lock"),
                    imageViewWidth: 50,
                    imageViewHeight: 70,
                    title: "출시 예정이에요!",
                    subTitle: "빠른 시일 내에 소개할 수 있도록 \n브릿지가 노력할게요:)",
                    subLabelHeight: 36,
                    marginBottom: 23.8
                )
                
            case .nothing:
                return HolderViewLayout(
                    image: UIImage(named: "placeholder.search"),
                    imageViewWidth: 100,
                    imageViewHeight: 100,
                    title: "올라온 모집글이 없어요!",
                    subTitle: "조금만 기달려 주세요.",
                    subLabelHeight: 21,
                    marginBottom: 3.8
                )
            }
        }
    }
    
    func configureHolderView(_ type: PlaceholderType) {
        holderImageView.image = type.holderViewLayout.image
        titleLabel.text = type.holderViewLayout.title
        subTitleLabel.configureTextWithLineHeight(
            text: type.holderViewLayout.subTitle,
            lineHeight: 18,
            alignment: .center
        )
        
        configureLayouts(type.holderViewLayout)
    }
}
