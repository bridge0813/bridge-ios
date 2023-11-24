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
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray07
        
        return view
    }()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
    }
}
