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
final class MainCategoryView: BaseView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let newButton = MainCategoryButton(.new)
    private let hotButton = MainCategoryButton(.hot)
    private let deadlineApproachButton = MainCategoryButton(.deadlineApproach)
    private let comingSoonButton = MainCategoryButton(.comingSoon)
    private let comingSoonButton2 = MainCategoryButton(.comingSoon)
    
    // MARK: - Layout
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
            flex.addItem().height(1).backgroundColor(BridgeColor.gray06)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

// MARK: - ButtonAction
extension MainCategoryView {
    enum CategoryButtonType: String {
        case new
        case hot
        case deadlineApproach
        case comingSoon
        case comingSoon2
    }
    
    var categoryButtonTapped: Observable<String> {
        Observable.merge(
            newButton.rx.tap.map { CategoryButtonType.new.rawValue },
            hotButton.rx.tap.map { CategoryButtonType.hot.rawValue },
            deadlineApproachButton.rx.tap.map { CategoryButtonType.deadlineApproach.rawValue },
            comingSoonButton.rx.tap.map { CategoryButtonType.comingSoon.rawValue },
            comingSoonButton2.rx.tap.map { CategoryButtonType.comingSoon2.rawValue }
        )
    }
    
    func updateButtonState(_ type: String) {
        let allButtons = [newButton, hotButton, deadlineApproachButton, comingSoonButton, comingSoonButton2]
        allButtons.forEach { $0.isSelected = false }
        
        if let buttonType = CategoryButtonType(rawValue: type) {
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
}
