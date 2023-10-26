//
//  AddedTechTagView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/25.
//

import UIKit
import FlexLayout
import PinLayout

/// 팀원에 대한 스택을 추가하면, 추가된 스택에 맞게 tag로 보여주는  뷰
final class AddedTechTagView: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray9
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    private var tagButtons: [BridgeFieldTagButton] = []
    
    // MARK: - Layout
    override func configureLayouts() {
        configureLayout()
    }
    
    private func configureLayout() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex
            .height(52)
            .direction(.row)
            .alignItems(.start)
            .wrap(.wrap)
            .define { flex in
                tagButtons.forEach { button in
                    flex.addItem(button).marginRight(14).marginBottom(14)
                }
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    func updateTagButtons(with titles: [String]) {
        // 기존 버튼 제거
        tagButtons.forEach { button in
            button.removeFromSuperview()
        }
        
        // 버튼 생성
        let buttons = titles.map { title in
            let button = BridgeFieldTagButton(title)
            button.changesSelectionAsPrimaryAction = false
            
            return button
        }
        tagButtons = buttons
        
        configureLayout()  // 버튼을 가지고 다시 레이아웃
        
        if titles.isEmpty {
            rootFlexContainer.flex.width(100%).height(52)
            rootFlexContainer.backgroundColor = BridgeColor.gray9
            
        } else {
            rootFlexContainer.flex.height(calculateContainerHeight())
            rootFlexContainer.backgroundColor = .clear
        }
    }
    
    /// button의 갯수를 파악하여, 컨테이너의 크기를 계산.
    private func calculateContainerHeight() -> CGFloat {
        let buttonHeight: CGFloat = 38
        let marginBottom: CGFloat = 14
        let buttonsPerRow = 3  // 한 행에 배치되는 버튼 갯수(임의 설정)
        
        // 버튼의 총 개수를 계산
        let totalButtons = tagButtons.count
        
        // 행의 개수를 계산(총 버튼의 개수를 3개씩 나눔)
        let numberOfRows = ceil(CGFloat(totalButtons) / CGFloat(buttonsPerRow))
        
        // 행의 높이와 marginBottom을 통해 총 높이 계산
        let totalHeight = (buttonHeight * numberOfRows) + (marginBottom * (numberOfRows - 1))
        
        return totalHeight
    }
}
