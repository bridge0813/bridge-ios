//
//  SectionDividerHeaderView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/15.
//

import UIKit
import FlexLayout
import PinLayout

/// 카테고리 '인기' 에서 섹션간 사이를 나누어주는 구분선 헤더뷰
final class SectionDividerHeaderView: BaseCollectionReusableView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).alignItems(.end).define { flex in
            flex.addItem().grow(1).height(8).backgroundColor(BridgeColor.gray07)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
