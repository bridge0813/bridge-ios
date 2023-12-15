//
//  ApplicantNumberHeaderView.swift
//  Bridge
//
//  Created by 엄지호 on 12/12/23.
//

import UIKit
import FlexLayout
import PinLayout

// TODO: - 통합 생각해보기.
/// 지원자가 몇 명인지 표시하는 헤더 뷰
final class ApplicantNumberHeaderView: BaseCollectionReusableView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let applicantNumberLabel: UILabel = {
        let label = UILabel()
        label.flex.width(100%).height(14)
        label.font = BridgeFont.body4.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).alignItems(.end).define { flex in
            flex.addItem(applicantNumberLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
// MARK: - Configuration
extension ApplicantNumberHeaderView {
    func configureLabel(with applicantNumber: Int) {
        applicantNumberLabel.highlightedTextColor(
            text: "지원자 \(applicantNumber)명",
            highlightedText: "\(applicantNumber)명"
        )
    }
}
