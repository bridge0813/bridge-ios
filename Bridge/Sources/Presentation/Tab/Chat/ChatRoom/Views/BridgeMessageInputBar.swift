//
//  BridgeMessageInputBar.swift
//  Bridge
//
//  Created by 정호윤 on 10/17/23.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift

final class BridgeMessageInputBar: BaseView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let messageInputTextView: UITextView = {
        let textView = UITextView()
        textView.font = BridgeFont.body2Long.font
        textView.textColor = BridgeColor.gray1
        return textView
    }()
    
    private let sendMessageButton = BridgeSendMessageButton()
    
    // MARK: - Layouts
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        let height: CGFloat = 38
        
        rootFlexContainer.flex.direction(.row).paddingHorizontal(16).paddingVertical(11).height(60).define { flex in
            flex.addItem(messageInputTextView).marginHorizontal(8).grow(1)
            flex.addItem(sendMessageButton).size(height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    override func bind() {
        messageInputTextView.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { !$0.isEmpty }
            .bind(to: sendMessageButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        sendMessageButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.messageInputTextView.text = nil
                owner.sendMessageButton.isEnabled = false
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Observables
extension BridgeMessageInputBar {
    var sendMessage: Observable<String> {
        messageInputTextView.rx.text.orEmpty
            .sample(sendMessageButton.rx.tap)
    }
}
