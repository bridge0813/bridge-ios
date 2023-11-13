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
    
    private let dDayLabel = BridgeChipLineLabel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray1
        label.numberOfLines = 0
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2Long.font
        label.textColor = BridgeColor.gray2
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.paddingHorizontal(16).define { flex in
            flex.addItem(dDayLabel).marginTop(24)
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
    
    func configureContents(with data: Project) {
        dDayLabel.text = "D-\(String(data.dDays))"
        titleLabel.configureTextWithLineHeight(text: data.title, lineHeight: 30)
        descriptionLabel.configureTextWithLineHeight(text: data.description, lineHeight: 20)
        
        dDayLabel.flex.width(dDayLabel.intrinsicContentSize.width).height(22)
        dDayLabel.flex.markDirty()
        setNeedsLayout()
    }
}
