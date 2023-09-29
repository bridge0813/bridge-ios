//
//  RecruiterMenuView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/29.
//

import UIKit
import FlexLayout
import PinLayout

// 2개의 버튼이 붙어있는 뷰
final class RecruiterMenuView: BaseView {
    private let rootFlexContainer = UIView()
    
    let leftButton: BridgeButton
    let rightButton: BridgeButton
    
    let dividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor.white
        return divider
    }()
    
    init(_ titles: (String, String)) {
        leftButton = BridgeButton(titles.0, style: .confirm)
        rightButton = BridgeButton(titles.1, style: .confirm)
        
        super.init(frame: .zero)
    }
    
    override func configureLayouts() {
        rootFlexContainer.backgroundColor = BridgeColor.primary1

        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).cornerRadius(4).define { flex in
            flex.addItem(leftButton).grow(1)
            flex.addItem(dividerView).width(0.4).height(20).alignSelf(.center)
            flex.addItem(rightButton).grow(1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
