//
//  TotalRecruitNumberHeaderView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/13.
//

import UIKit
import FlexLayout
import PinLayout

/// 총 모집인원의 수를 나타내는 헤더뷰
final class TotalRecruitNumberHeaderView: BaseCollectionReusableView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let recruitNumberLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body4.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).alignItems(.end).define { flex in
            flex.addItem(recruitNumberLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
// MARK: - Configuration
extension TotalRecruitNumberHeaderView {
    func configureLabel(with totalNumber: Int) {
        recruitNumberLabel.highlightedTextColor(
            text: "\(totalNumber)명 모집중",
            highlightedText: "\(totalNumber)명"
        )
    }
}
