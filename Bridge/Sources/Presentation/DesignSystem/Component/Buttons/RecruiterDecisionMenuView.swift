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
    
    let leftButton: BridgeButton
    let centerButton: BridgeButton
    let rightButton: BridgeButton
    
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
    
    init(_ titles: (String, String, String)) {
        leftButton = BridgeButton(titles.0, style: .confirm)
        centerButton = BridgeButton(titles.1, style: .confirm)
        rightButton = BridgeButton(titles.2, style: .confirm)
        
        super.init(frame: .zero)
    }
    
    override func configureLayouts() {
        rootFlexContainer.backgroundColor = BridgeColor.primary1

        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).cornerRadius(4).define { flex in
            flex.addItem(leftButton).grow(1).height(48)
            flex.addItem(leftDivider).width(0.3).height(28).alignSelf(.center)
            flex.addItem(centerButton).grow(1).height(48)
            flex.addItem(rightDivider).width(0.3).height(28).alignSelf(.center)
            flex.addItem(rightButton).grow(1).height(48)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
