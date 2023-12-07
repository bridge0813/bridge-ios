//
//  ChannelCell.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import UIKit
import FlexLayout
import PinLayout

final class ChannelCell: BaseTableViewCell {
    // MARK: - UI
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.backgroundColor = BridgeColor.gray09
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let lastMessageReceivedTimeLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.caption1.font
        label.textColor = BridgeColor.gray04
        return label
    }()
    
    private let lastMessageContentLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2Long.font
        label.textColor = BridgeColor.gray02
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let unreadMessageCountView = UnreadMessageCountView()
    
    // MARK: - Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
        // TODO: 프로필 사진 네트워킹 시 추가
        nameLabel.text = nil
        lastMessageReceivedTimeLabel.text = nil
        lastMessageContentLabel.text = nil
//        unreadMessageCountView.unreadMessageCountLabel.text = nil
    }
    
    // MARK: - Layout
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        contentView.flex.layout()
        return contentView.frame.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    override func configureLayouts() {
        contentView.flex.direction(.row).alignItems(.center).paddingHorizontal(16).define { flex in
            flex.addItem(profileImageView).size(48).marginRight(12)
            
            flex.addItem().width(200).define { flex in
                flex.addItem().direction(.row).marginBottom(4).define { flex in
                    flex.addItem(nameLabel).marginRight(8).shrink(1)
                    flex.addItem(lastMessageReceivedTimeLabel)
                }
                
                flex.addItem(lastMessageContentLabel)
            }
            
            flex.addItem().grow(1)
            
            flex.addItem(unreadMessageCountView)
        }
    }
}

// MARK: - Configuration
extension ChannelCell {
    func configure(with channel: Channel) {
        nameLabel.text = channel.name
        nameLabel.flex.markDirty()
        
        lastMessageReceivedTimeLabel.text = channel.lastMessage.receivedTime
        lastMessageReceivedTimeLabel.flex.markDirty()
        
        lastMessageContentLabel.text = channel.lastMessage.content
        lastMessageContentLabel.flex.markDirty()
        
        let unreadMessageCount = Int(channel.unreadMessageCount)
        unreadMessageCountView.configure(with: Int(channel.unreadMessageCount))
        unreadMessageCountView.flex.markDirty()
        
        contentView.flex.layout()
    }
}
