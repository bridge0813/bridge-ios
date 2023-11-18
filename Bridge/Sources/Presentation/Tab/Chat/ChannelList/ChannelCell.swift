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
    
    private let unreadMessageCountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemRed
        label.font = BridgeFont.caption1.font
        label.textColor = BridgeColor.gray09
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    // MARK: - Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
        lastMessageReceivedTimeLabel.text = nil
        lastMessageContentLabel.text = nil
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        contentView.flex.direction(.row).alignItems(.center).padding(20, 16).define { flex in
            flex.addItem(profileImageView).size(48).marginRight(12)
            
            flex.addItem().width(200).define { flex in
                flex.addItem().direction(.row).marginBottom(4).define { flex in
                    flex.addItem(nameLabel).marginRight(8)
                    flex.addItem(lastMessageReceivedTimeLabel)
                }
                
                flex.addItem(lastMessageContentLabel)
            }
            
            flex.addItem().grow(1)  // spacer
            
            flex.addItem(unreadMessageCountLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
}

// MARK: - Configuration
extension ChannelCell {
    func configure(with channel: Channel) {
        nameLabel.text = channel.name
        lastMessageReceivedTimeLabel.text = channel.lastMessage.receivedTime
        lastMessageContentLabel.text = channel.lastMessage.content
        configureUnreadMessageCountLabel(Int(channel.unreadMessageCount) ?? 0)
        
        profileImageView.flex.markDirty()
        nameLabel.flex.markDirty()
        lastMessageReceivedTimeLabel.flex.markDirty()
        unreadMessageCountLabel.flex.markDirty()
        contentView.flex.layout()
    }
}

// MARK: - 읽지 않은 메시지 개수에 따른 디스플레이 설정
private extension ChannelCell {
    func configureUnreadMessageCountLabel(_ unreadMessageCount: Int) {
        let displayState = UnreadMessageDisplayState(unreadMessageCount)
        
        unreadMessageCountLabel.flex.isIncludedInLayout(displayState.shouldIncludeInLayout)
        unreadMessageCountLabel.text = displayState.text
        
        let size = displayState.size(of: unreadMessageCountLabel.font)
        let width = max(size.width + 12, 18)
        unreadMessageCountLabel.flex.width(width).height(18).cornerRadius(9)
    }
    
    enum UnreadMessageDisplayState {
        case hidden
        case general(Int)
        case exceededLimit(Int)
        
        init(_ unreadMessageCount: Int, limit: Int = 999) {
            switch unreadMessageCount {
            case 0:             self = .hidden
            case 1 ... limit:   self = .general(unreadMessageCount)
            default:            self = .exceededLimit(limit)
            }
        }
        
        var text: String? {
            switch self {
            case .hidden:                   return nil
            case .general(let count):       return "\(count)"
            case .exceededLimit(let count): return "\(count)+"
            }
        }
        
        var shouldIncludeInLayout: Bool {
            switch self {
            case .hidden:                   return false
            case .general, .exceededLimit:  return true
            }
        }
        
        func size(of font: UIFont) -> CGSize {
            text?.size(withAttributes: [.font: font]) ?? CGSize()
        }
    }
}
