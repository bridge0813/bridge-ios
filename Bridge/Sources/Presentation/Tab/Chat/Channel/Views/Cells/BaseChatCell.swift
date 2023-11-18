//
//  BaseChatCell.swift
//  Bridge
//
//  Created by 정호윤 on 10/27/23.
//

import UIKit
import FlexLayout
import PinLayout

/// 채팅 셀의  레이아웃 등을 설정하는  base class
class BaseChatCell: BaseCollectionViewCell {
    // MARK: - UI
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = BridgeFont.caption1.font
        label.textColor = BridgeColor.gray03
        return label
    }()
    
    let chatBubble: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.caption1.font
        label.textColor = BridgeColor.gray03
        return label
    }()
    
    // MARK: - Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        timeLabel.text = nil
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
    
    func configure(with message: Message, shouldShowDate: Bool) {
        if shouldShowDate {
            dateLabel.isHidden = false
            dateLabel.text = message.sentDate
        } else {
            dateLabel.isHidden = true
        }
        
        timeLabel.text = message.sentTime
        configureMessageBubble(by: message.sender)
        configureLayout(by: message.sender)  // 보낸 사람에 따른 레이아웃(좌, 우) 설정
        
        dateLabel.flex.markDirty()
        chatBubble.flex.markDirty()
        timeLabel.flex.markDirty()
        contentView.flex.layout()
    }
}

// MARK: - Configuration
private extension BaseChatCell {
    func configureMessageBubble(by sender: Sender) {
        switch sender {
        case .me:
            chatBubble.backgroundColor = BridgeColor.primary1
            chatBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
            
        case .opponent:
            chatBubble.backgroundColor = BridgeColor.gray10
            chatBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    func configureLayout(by sender: Sender) {
        var alignment: Flex.AlignItems {
            switch sender {
            case .me:       return .end
            case .opponent: return .start
            }
        }
        
        contentView.flex.alignItems(alignment).paddingHorizontal(16).define { flex in
            flex.addItem(dateLabel).width(100%).marginBottom(24).isIncludedInLayout(!dateLabel.isHidden)
            flex.addItem(chatBubble)
            flex.addItem(timeLabel).marginTop(8)
        }
    }
}
