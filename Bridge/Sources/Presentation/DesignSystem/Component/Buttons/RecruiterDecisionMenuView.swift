//
//  RecruiterDecisionMenuView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/28.
//

import UIKit
import FlexLayout
import PinLayout

// 3개의 버튼이 붙어있는 뷰
final class RecruiterDecisionMenuView: BaseView {
    private let rootFlexContainer = UIView()
    
    let chatButton = BridgeButton("채팅하기", style: .confirm)
    let acceptButton = BridgeButton("수락하기", style: .confirm)
    let refuseButton = BridgeButton("거절하기", style: .confirm)
    
    let leftDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor.white
        return divider
    }()
    
    let rightDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor.white
        return divider
    }()
    
    override func configureLayouts() {
        rootFlexContainer.backgroundColor = BridgeColor.primary1

        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).cornerRadius(4).define { flex in
            flex.addItem(chatButton).grow(1).height(48)
            flex.addItem(leftDivider).width(0.3).height(28).alignSelf(.center)
            flex.addItem(acceptButton).grow(1).height(48)
            flex.addItem(rightDivider).width(0.3).height(28).alignSelf(.center)
            flex.addItem(refuseButton).grow(1).height(48)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
