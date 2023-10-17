//
//  MainCollectionHeaderView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/15.
//

import UIKit
import FlexLayout
import PinLayout

/// 모집글의 갯수를 나타내는 헤더뷰
final class ProjectCountHeaderView: BaseCollectionReusableView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let projectCountLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body4.font
        label.textColor = BridgeColor.gray3
        
        return label
    }()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).alignItems(.end).define { flex in
            flex.addItem(projectCountLabel).width(100).height(14).marginLeft(16)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
// MARK: - Configuration
extension ProjectCountHeaderView {
    func configureCountLabel(with count: String) {
        let labelText = "\(count)개의 프로젝트"
        let attributedString = NSMutableAttributedString(string: labelText)

        if let rangeOfNumber = labelText.range(of: "\(count)") {
            let nsRange = NSRange(rangeOfNumber, in: labelText)
            attributedString.addAttribute(.foregroundColor, value: BridgeColor.primary1, range: nsRange)
        }

        projectCountLabel.attributedText = attributedString
    }
}
