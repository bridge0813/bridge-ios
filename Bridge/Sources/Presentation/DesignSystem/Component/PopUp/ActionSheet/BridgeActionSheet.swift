//
//  BridgeActionSheet.swift
//  Bridge
//
//  Created by 엄지호 on 12/8/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 3개의 액션을 가지고 있는 CustomActionSheet
/// - Parameter titles: 각 액션의 title로 3개의 문자열을 받는다. ex - (String, String, String)
/// - Parameter isCheckmarked: 특정 액션을 선택했을 때, 체크마크 표시를 할 지 결정하는 플래그
final class BridgeActionSheet: BridgeBasePopUpView {
    // MARK: - UI
    private let firstActionButton: BridgeActionSheetButton = {
        let button = BridgeActionSheetButton()
        button.flex.width(100%).height(19)
        
        return button
    }()
    
    private let secondActionButton: BridgeActionSheetButton = {
        let button = BridgeActionSheetButton()
        button.flex.width(100%).height(19)
        
        return button
    }()
    
    private let thirdActionButton: BridgeActionSheetButton = {
        let button = BridgeActionSheetButton()
        button.flex.width(100%).height(19)
        
        return button
    }()
    
    // MARK: - Property
    override var containerHeight: CGFloat { 206 }
    override var dismissYPosition: CGFloat { 130 }
    
    /// 각 Menu 버튼의 title
    var titles: (String, String, String) {
        didSet {
            updateActionTitles()
            updateCheckmarked("first")  // 메뉴가 변경되면 가장 첫 번째 옵션에 체크마크.
        }
    }
    
    /// 선택되었다는 체크마크를 표시할 지 결정하는 플래그
    private let isCheckmarked: Bool
    
    var actionButtonTapped: Observable<String> {
        return Observable.merge(
            firstActionButton.rx.tap
                .withUnretained(self)
                .map { owner, _ in
                    owner.updateCheckmarked("first")
                    owner.hide()
                    return owner.firstActionButton.titleLabel?.text ?? ""
                },
            secondActionButton.rx.tap
                .withUnretained(self)
                .map { owner, _ in
                    owner.updateCheckmarked("second")
                    owner.hide()
                    return owner.secondActionButton.titleLabel?.text ?? ""
                },
            thirdActionButton.rx.tap
                .withUnretained(self)
                .map { owner, _ in
                    owner.updateCheckmarked("third")
                    owner.hide()
                    return owner.thirdActionButton.titleLabel?.text ?? ""
                }
        )
    }
    
    // MARK: - Init
    init(titles: (String, String, String), isCheckmarked: Bool) {
        self.titles = titles
        self.isCheckmarked = isCheckmarked
        
        super.init(frame: .zero)
        updateActionTitles()
        updateCheckmarked("first")
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        super.configureAttributes()
        addTapGestureForHide()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
        
        rootFlexContainer.flex.alignItems(.center).paddingHorizontal(18).define { flex in
            flex.addItem(dragHandleBar).marginTop(8)
            
            flex.addItem(firstActionButton).width(100%).height(19).marginTop(15)
            flex.addItem().backgroundColor(BridgeColor.gray09).width(100%).height(1).marginTop(16)
            
            flex.addItem(secondActionButton).width(100%).height(19).marginTop(16)
            flex.addItem().backgroundColor(BridgeColor.gray09).width(100%).height(1).marginTop(16)
            
            flex.addItem(thirdActionButton).width(100%).height(19).marginTop(16)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension BridgeActionSheet {
    private func updateActionTitles() {
        firstActionButton.title = titles.0
        secondActionButton.title = titles.1
        thirdActionButton.title = titles.2
    }
    
    private func updateCheckmarked(_ selectedButtonTitle: String) {
        guard isCheckmarked else { return }
        
        let allButtons = [firstActionButton, secondActionButton, thirdActionButton]
        allButtons.forEach { $0.isSelected = false }
        
        switch selectedButtonTitle {
        case "first": firstActionButton.isSelected = true
        case "second": secondActionButton.isSelected = true
        case "third": thirdActionButton.isSelected = true
        default: print("Error")
        }
    }
}
