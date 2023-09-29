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
        let leftDivider = createDividerView()
        let rightDivider = createDividerView()
        
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).define { flex in
            flex.addItem(chatButton).grow(1).height(48)
            flex.addItem(leftDivider).width(0.3).height(28).alignSelf(.center)
            flex.addItem(acceptButton).grow(1).height(48).cornerRadius(0)
            flex.addItem(rightDivider).width(0.3).height(28).alignSelf(.center)
            flex.addItem(refuseButton).grow(1).height(48)
        }
        
        applyCornerStyles()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    private func applyCornerStyles() {
        chatButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        refuseButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    private func createDividerView() -> UIView {
        let divider = UIView()
        divider.backgroundColor = UIColor.white
        return divider
    }
}
