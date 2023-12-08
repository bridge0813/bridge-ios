//
//  MenuPopUpView.swift
//  Bridge
//
//  Created by 엄지호 on 12/8/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 3단 메뉴 팝업 뷰로 초기화 시 3가지 메뉴의 제목을 받는다. ex) - (String, String, String)
final class MenuPopUpView: BridgeBasePopUpView {
    // MARK: - UI
    private let firstMenuButton: MenuButton = {
        let button = MenuButton()
        button.flex.width(100%).height(19)
        
        return button
    }()
    
    private let secondMenuButton: MenuButton = {
        let button = MenuButton()
        button.flex.width(100%).height(19)
        
        return button
    }()
    
    private let thirdMenuButton: MenuButton = {
        let button = MenuButton()
        button.flex.width(100%).height(19)
        
        return button
    }()
    
    // MARK: - Property
    override var containerHeight: CGFloat { 206 }
    override var dismissYPosition: CGFloat { 130 }
    
    /// 선택되었다는 체크마크를 표시할 지 결정하는 플래그
    private let isCheckmarked: Bool
    
    var menuTapped: Observable<String> {
        return Observable.merge(
            firstMenuButton.rx.tap
                .withUnretained(self)
                .map { owner, _ in
                    owner.updateCheckmarked("first")
                    owner.hide()
                    return owner.firstMenuButton.titleLabel?.text ?? ""
                },
            secondMenuButton.rx.tap
                .withUnretained(self)
                .map { owner, _ in
                    owner.updateCheckmarked("second")
                    owner.hide()
                    return owner.secondMenuButton.titleLabel?.text ?? ""
                },
            thirdMenuButton.rx.tap
                .withUnretained(self)
                .map { owner, _ in
                    owner.updateCheckmarked("third")
                    owner.hide()
                    return owner.thirdMenuButton.titleLabel?.text ?? ""
                }
        )
    }
    
    // MARK: - Init
    init(_ titles: (String, String, String), isCheckmarked: Bool) {
        firstMenuButton.title = titles.0
        secondMenuButton.title = titles.1
        thirdMenuButton.title = titles.2
        
        self.isCheckmarked = isCheckmarked
        super.init(frame: .zero)
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        super.configureAttributes()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
        
        rootFlexContainer.flex.alignItems(.center).paddingHorizontal(18).define { flex in
            flex.addItem(dragHandleBar).marginTop(8)
            
            flex.addItem(firstMenuButton).width(100%).height(19).marginTop(15)
            flex.addItem().backgroundColor(BridgeColor.gray09).width(100%).height(1).marginTop(16)
            
            flex.addItem(secondMenuButton).width(100%).height(19).marginTop(16)
            flex.addItem().backgroundColor(BridgeColor.gray09).width(100%).height(1).marginTop(16)
            
            flex.addItem(thirdMenuButton).width(100%).height(19).marginTop(16)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension MenuPopUpView {
    func updateMenuTitles(_ titles: (String, String, String)) {
        firstMenuButton.title = titles.0
        secondMenuButton.title = titles.1
        thirdMenuButton.title = titles.2
    }
    
    private func updateCheckmarked(_ selectedButtonTitle: String) {
        guard isCheckmarked else { return }
        
        let allButtons = [firstMenuButton, secondMenuButton, thirdMenuButton]
        allButtons.forEach { $0.isSelected = false }
        
        switch selectedButtonTitle {
        case "first": firstMenuButton.isSelected = true
        case "second": secondMenuButton.isSelected = true
        case "third": thirdMenuButton.isSelected = true
        default: print("Error")
        }
    }
}
