//
//  BridgeMessageInputView.swift
//  Bridge
//
//  Created by 정호윤 on 10/17/23.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift

final class BridgeMessageInputView: BaseView {
    
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.primary2
        return view
    }()
    
    private let messageInputTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = BridgeFont.body2Long.font
        textField.textColor = BridgeColor.gray1
        return textField
    }()
    
    private let sendMessageButton = BridgeSendMessageButton()
    
    // MARK: - Layouts
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        let height: CGFloat = 38
        
        rootFlexContainer.flex.direction(.row).alignItems(.center).paddingHorizontal(16).height(60).define { flex in
            flex.addItem(messageInputTextField).width(250).height(height).marginHorizontal(8)
            flex.addItem().grow(1)
            flex.addItem(sendMessageButton).size(height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    override func bind() {
        messageInputTextField.rx.text
            .orEmpty
            .map { !$0.isEmpty }
            .bind(to: sendMessageButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

// MARK: - Observables
extension BridgeMessageInputView {
    var sendMessage: Observable<Void> {
        sendMessageButton.rx.tap.asObservable()
    }
}
