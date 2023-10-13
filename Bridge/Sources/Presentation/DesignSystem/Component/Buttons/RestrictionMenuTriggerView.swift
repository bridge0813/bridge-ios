//
//  RestrictionMenuTriggerView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit
import FlexLayout
import PinLayout

final class RestrictionMenuTriggerView: BaseView {
    private let rootFlexContainer = UIView()
    
    let restrictionTypeLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .black,
            font: .boldSystemFont(ofSize: 14)
        )
        label.text = "학생"
        
        return label
    }()
    
    let arrowButton = MenuToggleArrowButton()
    
    override func configureLayouts() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        addSubview(rootFlexContainer)
        rootFlexContainer.flex
            .direction(.row)
            .justifyContent(.spaceBetween)
            .alignItems(.center)
            .padding(10)
            .define { flex in
                flex.addItem(restrictionTypeLabel).width(40).marginLeft(5)
                flex.addItem(arrowButton).size(20).cornerRadius(10).marginRight(5)
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
