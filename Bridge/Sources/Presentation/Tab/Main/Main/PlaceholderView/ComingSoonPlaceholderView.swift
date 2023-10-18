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
final class ComingSoonPlaceholderView: BaseCollectionReusableView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let holderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder.lock")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "출시 예정이에요!"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        label.textAlignment = .center
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.configureTextWithLineHeight(
            text: "빠른 시일 내에 소개할 수 있도록 \n브릿지가 노력할게요:)",
            lineHeight: 18,
            alignment: .center
        )
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray4
        label.numberOfLines = 2
        
        return label
    }()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.alignItems(.center).define { flex in
            flex.addItem(holderImageView).width(50).height(70).marginBottom(23.8)
            flex.addItem(titleLabel).marginBottom(4)
            flex.addItem(subTitleLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
