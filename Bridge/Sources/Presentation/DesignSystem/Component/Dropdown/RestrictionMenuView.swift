//
//  RestrictionMenuView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit
import FlexLayout
import PinLayout

final class RestrictionMenuView: BaseView {
    private let rootFlexContainer = UIView()
    
    let studentButton = DropdownMenuButton(title: "  학생")
    let currentEmployeeButton = DropdownMenuButton(title: "  현직자")
    let jobSeekerButton = DropdownMenuButton(title: "  취준생")
    
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.column).define { flex in
            flex.addItem(studentButton).height(45)
            flex.addItem(currentEmployeeButton).height(45)
            flex.addItem(jobSeekerButton).height(45)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
