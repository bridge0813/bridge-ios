//
//  TopMenuView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/19.
//

import UIKit
import FlexLayout
import PinLayout

/// 홈화면에서 가장 상위에 위치한 메뉴 뷰(분야선택 메뉴, 필터버튼, 검색버튼)
final class TopMenuView: BaseView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    let fieldCategoryAnchorButton = FieldCategoryAnchorButton()
    lazy var fieldDropdown: DropDown = {
        let dropdown = DropDown(
            anchorView: fieldCategoryAnchorButton,
            bottomOffset: CGPoint(x: 10, y: 0),
            dataSource: ["UI/UX", "전체"],
            cellHeight: 46,
            itemTextColor: BridgeColor.gray03,
            itemTextFont: BridgeFont.body2.font,
            selectedItemTextColor: BridgeColor.gray01,
            dimmedBackgroundColor: .black.withAlphaComponent(0.3),
            width: 147,
            cornerRadius: 4
        )
        
        return dropdown
    }()

    let filterButton: UIButton = {
        let buttonImage = UIImage(named: "hamburger")?
            .resize(to: CGSize(width: 24, height: 24))
            
        let button = UIButton()
        button.setImage(buttonImage, for: .normal)
        return button
    }()

    let searchButton: UIButton = {
        let buttonImage = UIImage(named: "magnifyingglass")?
            .resize(to: CGSize(width: 24, height: 24))
            
        let button = UIButton()
        button.setImage(buttonImage, for: .normal)
        return button
    }()

    let dividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = BridgeColor.gray06
        divider.isHidden = true
        
        return divider
    }()

    // MARK: - Configurations
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.column).height(44).define { flex in
            flex.addItem().direction(.row).alignItems(.center).define { flex in
                flex.addItem(fieldCategoryAnchorButton).marginLeft(5)
                flex.addItem().grow(1)
                flex.addItem(filterButton).size(24).marginRight(8)
                flex.addItem(searchButton).size(24).marginRight(15)
            }
            
            flex.addItem().grow(1)
            flex.addItem(dividerView).height(1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
