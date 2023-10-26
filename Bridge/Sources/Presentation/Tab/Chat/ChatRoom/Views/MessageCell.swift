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
        label.textAlignment = .center
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
    func configure(with message: Message, shouldShowDate: Bool) {
        // 날짜 바뀔때만 보여주도록 설정 (e.g. 20XX년 XX월 XX일)
        if shouldShowDate {
            dateLabel.text = message.sentDate
            dateLabel.isHidden = false
        } else {
            dateLabel.isHidden = true
        }
        
        messageContainerView.configure(with: message)   // 메시지 컨텐츠 설정
        timeLabel.text = message.sentTime               // 보낸 시간(e.g. 오전 10:00) 설정
        
        configureLayouts(by: message.sender)  // 보낸 사람에 따른 레이아웃(좌, 우) 및 배경색 설정
    }
}

// MARK: - Reconfigure layout
private extension MessageCell {
    func configureLayouts(by sender: Sender) {
        var alignItems: Flex.AlignItems
        
        if sender == .me { alignItems = .end }
        else { alignItems = .start }
        
        contentView.flex.paddingHorizontal(16).alignItems(alignItems).define { flex in
            flex.addItem(dateLabel).width(100%).marginBottom(24).isIncludedInLayout(!dateLabel.isHidden)
            flex.addItem(messageContainerView).backgroundColor(.clear).grow(1)
            flex.addItem(timeLabel).marginTop(8)
        }
        
        contentView.flex.layout()
    }
}
