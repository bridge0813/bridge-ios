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
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let newButton = MainCategoryButton(.new)
    private let hotButton = MainCategoryButton(.hot)
    private let deadlineApproachButton = MainCategoryButton(.deadlineApproach)
    private let comingSoonButton = MainCategoryButton(.comingSoon)
    private let comingSoonButton2 = MainCategoryButton(.comingSoon)
    
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
    var categoryButtonTapped: Observable<String> {
        Observable.merge(
            newButton.rx.tap.map { "new" },
            hotButton.rx.tap.map { "hot" },
            deadlineApproachButton.rx.tap.map { "deadlineApproach" },
            comingSoonButton.rx.tap.map { "comingSoon" },
            comingSoonButton2.rx.tap.map { "comingSoon2" }
        )
    }
    
    func updateButtonState(_ type: String) {
        let allButtons = [newButton, hotButton, deadlineApproachButton, comingSoonButton, comingSoonButton2]
        allButtons.forEach { $0.isSelected = false }
        
        switch type {
        case "new":
            newButton.isSelected = true
            
        case "hot":
            hotButton.isSelected = true
            
        case "deadlineApproach":
            deadlineApproachButton.isSelected = true
            
        case "comingSoon":
            comingSoonButton.isSelected = true
            
        case "comingSoon2":
            comingSoonButton2.isSelected = true
            
        default:
            print("type")
        }
    }
}
