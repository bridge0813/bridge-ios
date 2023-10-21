//
//  EmptyProjectPlaceholderView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/18.
//

import UIKit
import FlexLayout
import PinLayout

/// 모집글이 없을 경우 사용되는 FooterView
final class EmptyProjectPlaceholderView: BaseCollectionReusableView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let holderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder.search")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "올라온 모집글이 없어요!"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        label.textAlignment = .center
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "조금만 기달려 주세요."
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray4
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.alignItems(.center).define { flex in
            flex.addItem(holderImageView).size(100).marginBottom(4)
            flex.addItem(titleLabel).marginBottom(6)
            flex.addItem(subTitleLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
