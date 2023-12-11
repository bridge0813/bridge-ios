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
    
    // 읽음 여부 및 전송 시간 레이블의 컨테이너 뷰
    private let statusContainerView = UIView()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.caption1.font
        label.textColor = BridgeColor.gray03
        return label
    }()
    
    private let readStatusLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.caption1.font
        label.textColor = BridgeColor.gray03
        return label
    }()
    
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
    
    func configure(with message: Message, shouldShowDate: Bool, shouldShowReadStatus: Bool) {
        if shouldShowDate {
            dateLabel.isHidden = false
            dateLabel.text = message.sentDate
        } else {
            dateLabel.isHidden = true
        }
        
        timeLabel.text = message.sentTime
        
        if shouldShowReadStatus {
            readStatusLabel.text = "읽음"
        } else {
            readStatusLabel.text = nil
        }
        
        configureMessageBubble(by: message.sender)
        
        configureLayout(by: message.sender)  // 보낸 사람에 따른 레이아웃(좌, 우) 설정
        
        dateLabel.flex.markDirty()
        timeLabel.flex.markDirty()
        readStatusLabel.flex.markDirty()
        chatBubble.flex.markDirty()
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
        switch sender {
        case .me:
            contentView.flex.alignItems(.end).paddingHorizontal(16).define { flex in
                flex.addItem(dateLabel).width(100%).marginBottom(24).isIncludedInLayout(!dateLabel.isHidden)
                flex.addItem(chatBubble)
                flex.addItem(statusContainerView).direction(.row).marginTop(8).define { flex in
                    flex.addItem(readStatusLabel).marginRight(12)
                    flex.addItem(timeLabel)
                }
            }
            
        case .opponent:
            contentView.flex.alignItems(.start).paddingHorizontal(16).define { flex in
                flex.addItem(dateLabel).width(100%).marginBottom(24).isIncludedInLayout(!dateLabel.isHidden)
                flex.addItem(chatBubble)
                flex.addItem(statusContainerView).direction(.row).marginTop(8).define { flex in
                    flex.addItem(timeLabel)
                }
            }
        }
    }
}
