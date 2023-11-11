//
//  FirstSectionView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/10.
//

import UIKit
import FlexLayout
import PinLayout

/// 상세 모집글의 첫 번째 섹션(제목, 소개 등)
final class FirstSectionView: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        
        return view
    }()
    
    private let dDayLabel: BridgeChipLineLabel = {
        let label = BridgeChipLineLabel()
        label.text = "D-12"
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.configureTextWithLineHeight(text: "사이드 프젝으로 IOS앱을 같이 구현할 팀원을 구하고 있어요~", lineHeight: 30)
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray1
        label.numberOfLines = 0
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.configureTextWithLineHeight(text: "당신이 찾고 있는 팀원의\n정보를 알려주세요!", lineHeight: 20)
        label.font = BridgeFont.body2Long.font
        label.textColor = BridgeColor.gray2
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Property
    
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.paddingHorizontal(16).define { flex in
            flex.addItem(dDayLabel).width(dDayLabel.intrinsicContentSize.width).height(22).marginTop(24)
            flex.addItem(titleLabel).height(60).marginTop(16).marginRight(49)
            flex.addItem(descriptionLabel).marginTop(8)
            flex.addItem().height(32)  // 바텀마진
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
