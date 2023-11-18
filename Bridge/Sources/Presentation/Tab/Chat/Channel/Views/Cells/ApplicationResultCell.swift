//
//  ApplicationResultCell.swift
//  Bridge
//
//  Created by 정호윤 on 10/28/23.
//

import UIKit
import FlexLayout
import PinLayout

/// 프로젝트 지원 결과(수락 or 거절)를 나타내는 셀
final class ApplicationResultCell: BaseChatCell {
    // MARK: - UI
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2Long.font
        label.textAlignment = .center
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = 188
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private let emojiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = ""
        emojiImageView.image = nil
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
        configureImageView(by: message.type)
        
        chatBubble.flex.alignItems(.center).width(messageLabel.intrinsicContentSize.width + 48).padding(24).define { flex in
            flex.addItem(messageLabel).marginBottom(6)
            flex.addItem(emojiImageView).size(100)
        }
        
        super.configure(with: message, shouldShowDate: shouldShowDate)
    }
}

private extension ApplicationResultCell {
    func configureMessageLabel(with message: Message) {
        switch message.sender {
        case .me:       messageLabel.textColor = BridgeColor.gray10
        case .opponent: messageLabel.textColor = BridgeColor.gray01
        }
        
        switch message.type {
        case .accept:   messageLabel.text = "소중한 지원 감사드립니다!\n저희 프로젝트에 참여해주실래요?"
        case .reject:   messageLabel.text = "소중한 지원 감사드립니다!\n아쉽지만 다음 기회에 같이해요..."
        default:        break
        }
    }
    
    func configureImageView(by messageType: MessageType) {
        switch messageType {
        case .accept:   emojiImageView.image = UIImage(named: "graphic_handshake")
        case .reject:   emojiImageView.image = UIImage(named: "graphic_refuse")
        default:        break
        }
    }
}
