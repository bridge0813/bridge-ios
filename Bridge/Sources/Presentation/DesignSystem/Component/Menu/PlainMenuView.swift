//
//  PlainMenuView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit
import FlexLayout
import PinLayout

final class PlainMenuView: BaseView {
    private let rootFlexContainer = UIView()
    
    let cancelButton = PlainTextMenuButton(title: "지원취소")
    let deleteButton = PlainTextMenuButton(title: "삭제하기")
    
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.direction(.column).padding(5).define { flex in
            flex.addItem(cancelButton).marginBottom(5)
            flex.addItem(deleteButton)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
