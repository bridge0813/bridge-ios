//
//  MainCategoryHeaderView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/12.
//

import UIKit
import FlexLayout
import PinLayout

final class MainCategoryHeaderView: BaseView {
    // MARK: - Properties
    private let rootFlexContainer = UIView()
    
    private let newButton = MainCategoryButton(
        title: "신규",
        normalImageName: "main.sprouts.off",
        selectedImageName: "main.sprouts.on"
    )
    
    private let hotButton = MainCategoryButton(
        title: "인기",
        normalImageName: "main.trophy.off",
        selectedImageName: "main.trophy.on"
    )
    
    private let deadlineApproachButton = MainCategoryButton(
        title: "마감임박",
        normalImageName: "main.bomb.off",
        selectedImageName: "main.bomb.on"
    )
    
    private let comingSoonButton = MainCategoryButton(
        title: "출시예정",
        normalImageName: "main.mysterybox.off",
        selectedImageName: "main.mysterybox.on"
    )
    
    private let comingSoonButton2 = MainCategoryButton(
        title: "출시예정",
        normalImageName: "main.mysterybox.off",
        selectedImageName: "main.mysterybox.on"
    )
    
    // MARK: - Configurations
    override func configureLayouts() {
        clipsToBounds = true
        layer.cornerRadius = 8
        
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).alignItems(.center).define { flex in
            flex.addItem(newButton)
            flex.addItem().grow(1)
            flex.addItem(hotButton)
            flex.addItem().grow(1)
            flex.addItem(deadlineApproachButton)
            flex.addItem().grow(1)
            flex.addItem(comingSoonButton)
            flex.addItem().grow(1)
            flex.addItem(comingSoonButton2)
        }
    }
    
    override func configureAttributes() {
        newButton.isSelected = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

extension MainCategoryHeaderView {
    enum MainCategoryButtonType: String {
        case new
        case hot
        case deadlineApproach
        case comingSoon
    }
}
