//
//  BridgeSmallButtonGroup.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/29.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

// 2개의 버튼이 붙어있는 뷰
final class BridgeSmallButtonGroup: BaseView {
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.primary1
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    private let leftButton: BridgeButton
    private let rightButton: BridgeButton
    
    // MARK: - Property
    var buttonGroupTapped: Observable<String> {
        Observable.merge(
            leftButton.rx.tap.map { [weak self] in self?.leftButton.titleLabel?.text ?? "" },
            rightButton.rx.tap.map { [weak self] in self?.rightButton.titleLabel?.text ?? "" }
        )
    }
    
    // MARK: - Init
    init(_ titles: (String, String)) {
        leftButton = BridgeButton(title: titles.0, font: BridgeFont.button2.font, backgroundColor: BridgeColor.primary1)
        rightButton = BridgeButton(title: titles.1, font: BridgeFont.button2.font, backgroundColor: BridgeColor.primary1)
        
        super.init(frame: .zero)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        let dividerColor = BridgeColor.gray10.withAlphaComponent(0.4)
        
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).define { flex in
            flex.addItem(leftButton).grow(1)
            flex.addItem().alignSelf(.center).backgroundColor(dividerColor).width(0.4).height(20)
            flex.addItem(rightButton).grow(1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
