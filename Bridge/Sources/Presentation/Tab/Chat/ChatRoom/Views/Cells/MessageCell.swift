//
//  MessageCell.swift
//  Bridge
//
//  Created by 정호윤 on 10/20/23.
//

import UIKit
import FlexLayout
import PinLayout

/// 메시지만 갖는 셀
final class MessageCell: ChatCell {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2Long.font
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = 188
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = ""
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustHeight)
        return contentView.frame.size
    }
    
    // MARK: - Configuration
    override func configure(with message: Message, shouldShowDate: Bool) {
        configureMessageLabel(with: message)
        
        chatBubble.flex.width(messageLabel.intrinsicContentSize.width + 48).padding(12, 24).define { flex in
            flex.addItem(messageLabel)
        }
        
        super.configure(with: message, shouldShowDate: shouldShowDate)
    }
}

private extension MessageCell {
    func configureMessageLabel(with message: Message) {
        messageLabel.text = message.type.content
        
        switch message.sender {
        case .me:       messageLabel.textColor = BridgeColor.gray10
        case .opponent: messageLabel.textColor = BridgeColor.gray01
        }
    }
}
