//
//  MessageContainerView.swift
//  Bridge
//
//  Created by 정호윤 on 10/22/23.
//

import UIKit
import FlexLayout
import PinLayout

final class MessageContainerView: BaseView {
    
    private let messageBubble: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2Long.font
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = 188
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(messageBubble)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        messageBubble.pin.all()
        messageBubble.flex.layout(mode: .adjustHeight)
    }
    
    func configure(with message: Message) {
        configureMessageContainerView(by: message.sender)
        configureMessageLabel(with: message.type)
        
        messageBubble.flex.width(messageLabel.intrinsicContentSize.width + 48).define { flex in
            flex.addItem(messageLabel).margin(12, 24)
        }
    }
}

private extension MessageContainerView {
    func configureMessageContainerView(by sender: Sender) {
        switch sender {
        case .me:
            messageBubble.backgroundColor = BridgeColor.primary1
            messageBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
            messageLabel.textColor = BridgeColor.gray10
            
        case .opponent:
            messageBubble.backgroundColor = BridgeColor.gray10
            messageBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            messageLabel.textColor = BridgeColor.gray1
        }
    }
    
    func configureMessageLabel(with messageType: MessageType) {
        switch messageType {
        case .text(let content):    messageLabel.text = content
        default:                    break
        }
    }
}
