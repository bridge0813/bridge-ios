//
//  MessageCell.swift
//  Bridge
//
//  Created by 정호윤 on 10/20/23.
//

import UIKit
import FlexLayout
import PinLayout

final class MessageCell: BaseCollectionViewCell {
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.caption1.font
        label.textColor = BridgeColor.gray3
        return label
    }()
    
    private let messageContainerView = MessageContainerView()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.caption1.font
        label.textColor = BridgeColor.gray3
        return label
    }()
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    // 출처: https://medium.com/daangn/how-to-use-flexlayout-effectively-sunsetting-texture-asyncdisplaykit-ca7e3f5c8441
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.bounds.size.width = size.width
        contentView.flex.layout(mode: .adjustHeight)
        return contentView.frame.size
    }
}

// MARK: - Cell configuration
extension MessageCell {
    func configureCell(with message: Message) {
//        dateLabel.text = message.sentTime
        timeLabel.text = message.sentTime
        configureLayouts(by: message.sender)
        messageContainerView.configure(with: message)
    }
}

// MARK: - Reconfigure layout
extension MessageCell {
    func configureLayouts(by sender: Sender) {
        var alignItems: Flex.AlignItems
        
        if sender == .me { alignItems = .end }
        else { alignItems = .start }
        
        contentView.flex.paddingHorizontal(16).alignItems(alignItems).define { flex in
            flex.addItem(dateLabel)
            flex.addItem(messageContainerView).backgroundColor(.clear).grow(1)
            flex.addItem(timeLabel).marginTop(8)
        }
    }
}
