//
//  MainCategoryHeaderView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/12.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// '신규', '인기', '마감임박', '출시예정' 카테고리를 나타내는 뷰
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
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.column).define { flex in
            flex.addItem().grow(1)
            flex.addItem().direction(.row).alignItems(.center).marginHorizontal(5).define { flex in
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
            
            flex.addItem().grow(1)
            flex.addItem().height(1).backgroundColor(BridgeColor.gray6)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
}

// MARK: - ButtonAction
extension MainCategoryHeaderView {
    var categoryButtonTapped: Observable<MainViewModel.CategoryButtonType> {
        Observable.merge(
            newButton.rx.tap.map { MainViewModel.CategoryButtonType.new },
            hotButton.rx.tap.map { MainViewModel.CategoryButtonType.hot },
            deadlineApproachButton.rx.tap.map { MainViewModel.CategoryButtonType.deadlineApproach },
            comingSoonButton.rx.tap.map { MainViewModel.CategoryButtonType.comingSoon },
            comingSoonButton2.rx.tap.map { MainViewModel.CategoryButtonType.comingSoon2 }
        )
    }
    
    func updateButtonState(_ buttonType: MainViewModel.CategoryButtonType) {
        let allButtons = [newButton, hotButton, deadlineApproachButton, comingSoonButton, comingSoonButton2]
        
        // 모든 버튼의 상태를 해제
        allButtons.forEach { $0.isSelected = false }
        
        switch buttonType {
        case .new:
            newButton.isSelected = true
            
        case .hot:
            hotButton.isSelected = true
            
        case .deadlineApproach:
            deadlineApproachButton.isSelected = true
            
        case .comingSoon:
            comingSoonButton.isSelected = true
            
        case .comingSoon2:
            comingSoonButton2.isSelected = true
        }
    }
}
