//
//  RecruiterDecisionMenuView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/28.
//

import UIKit
import FlexLayout
import PinLayout

final class RecruiterDecisionMenuView: BaseView {
    private let rootFlexContainer = UIView()
    
    let chatButton = BridgeBlockButton(with: "채팅하기", style: .confirm)
    let acceptButton = BridgeBlockButton(with: "수락하기", style: .confirm)
    let refuseButton = BridgeBlockButton(with: "거절하기", style: .confirm)
    
    override func configureLayouts() {
        applyCornerStyles()
    
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).define { flex in
            flex.addItem(chatButton).grow(1).height(48)
            flex.addItem(acceptButton).grow(1).height(48).cornerRadius(0)
            flex.addItem(refuseButton).grow(1).height(48)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
        acceptButton.layer.addDividerBorders([.left, .right])
    }
    
    private func applyCornerStyles() {
        chatButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        refuseButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
}

extension CALayer {
    // 뷰의 layer 왼쪽, 오른쪽 위치에 원하는 크기만큼 보더라인을 그려주는 메서드.
    func addDividerBorders(_ edges: [UIRectEdge]) {
        for edge in edges {
            let border = CALayer()
            let borderWidth: CGFloat = 0.3
            let borderHeight: CGFloat = 28

            let verticalOffset = (frame.height - borderHeight) / 2  // 구분선이 가운데에 위치하도록
            let leftBorderFrame = CGRect(x: 0, y: verticalOffset, width: borderWidth, height: borderHeight)
            let rightBorderFrame = CGRect(x: frame.width - borderWidth, y: verticalOffset, width: 0.3, height: borderHeight)
            
            border.frame = edge == .left ? leftBorderFrame : rightBorderFrame
            border.backgroundColor = UIColor.white.cgColor
            
            self.addSublayer(border)
        }
    }
}
