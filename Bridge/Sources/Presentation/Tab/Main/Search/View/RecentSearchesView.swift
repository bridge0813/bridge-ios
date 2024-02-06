//
//  RecentSearchesView.swift
//  Bridge
//
//  Created by 엄지호 on 2/6/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

final class RecentSearchesView: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.flex.width(73).height(24)
        label.text = "최근 검색어"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle2.font
        return label
    }()
    
    private let removeAllButton: UIButton = {
        let button = UIButton()
        button.flex.width(45).height(14)
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(BridgeColor.gray04, for: .normal)
        button.titleLabel?.font = BridgeFont.caption1.font
        return button
    }()
    
    private let dividerView: UIView = {
        let divider = UIView()
        divider.flex.width(1).height(10)
        divider.backgroundColor = BridgeColor.gray06
        return divider
    }()
    
    private let toggleSearchHistoryButton: UIButton = {
        let button = UIButton()
        button.flex.width(66).height(14)
        button.setTitle("저장기능 끄기", for: .normal)
        button.setTitleColor(BridgeColor.gray04, for: .normal)
        button.titleLabel?.font = BridgeFont.caption1.font
        return button
    }()
    
    // MARK: - Property
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.padding(24, 15, 0, 15).define { flex in
            flex.addItem().direction(.row).justifyContent(.spaceBetween).alignItems(.center).define { flex in
                flex.addItem(titleLabel)
                flex.addItem().width(139).direction(.row).alignItems(.center).define { flex in
                    flex.addItem(removeAllButton)
                    flex.addItem(dividerView).marginLeft(14)
                    flex.addItem(toggleSearchHistoryButton).marginLeft(14)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - bind
    override func bind() {
        
    }
}
