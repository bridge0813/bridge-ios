//
//  ChatRoomCell.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import UIKit
import FlexLayout
import PinLayout

final class ChatRoomCell: BaseTableViewCell {
    
    // MARK: - UI
    private let chatRoomBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray4
        imageView.layer.cornerRadius = 22
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let latestMessageReceivedTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private let latestMessageContentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let unreadMessageCountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemRed
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = nil
        nameLabel.text = ""
        latestMessageReceivedTimeLabel.text = ""
        latestMessageContentLabel.text = ""
    }
    
    // MARK: - Layouts
    override func configureLayouts() {
        contentView.addSubview(chatRoomBackgroundView)
        
        let componentOffset: CGFloat = 8
        let containerOffset: CGFloat = 24
        
        chatRoomBackgroundView.flex.direction(.row).alignItems(.center).define { flex in
            flex.addItem(profileImageView).size(44).marginLeft(containerOffset)
            
            flex.addItem().direction(.column).width(192).marginHorizontal(16).define { flex in
                flex.addItem().direction(.row).marginBottom(componentOffset).define { flex in
                    flex.addItem(nameLabel).shrink(1)
                    flex.addItem().size(componentOffset)
                    flex.addItem(latestMessageReceivedTimeLabel).grow(1)
                }
                
                flex.addItem(latestMessageContentLabel)
            }
            
            flex.addItem(unreadMessageCountLabel).position(.absolute).right(containerOffset)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horizontalMargin: CGFloat = 16
        let verticalMargin: CGFloat = 8
        chatRoomBackgroundView.pin.horizontally(horizontalMargin).vertically(verticalMargin)
        chatRoomBackgroundView.flex.layout()
    }
}

// MARK: - Configuration
extension ChatRoomCell {
    func configureCell(with chatRoom: ChatRoom) {
        nameLabel.text = chatRoom.name
        latestMessageReceivedTimeLabel.text = chatRoom.latestMessage.receivedTime
        latestMessageContentLabel.text = chatRoom.latestMessage.content
        configureUnreadMessageCountLabel(Int(chatRoom.unreadMessageCount) ?? 0)
    }
}

// MARK: - 읽지 않은 메시지 개수에 따른 디스플레이 설정
private extension ChatRoomCell {
    func configureUnreadMessageCountLabel(_ unreadMessageCount: Int) {
        let displayState = UnreadMessageDisplayState(unreadMessageCount)
        
        unreadMessageCountLabel.flex.isIncludedInLayout(displayState.shouldIncludeInLayout)
        unreadMessageCountLabel.text = displayState.text
        
        let size = displayState.size(of: unreadMessageCountLabel.font)
        let width = max(size.width + 6, 18)
        unreadMessageCountLabel.flex.width(width).height(18).cornerRadius(9)
    }
    
    enum UnreadMessageDisplayState {
        case hidden
        case general(Int)
        case exceededLimit(Int)
        
        init(_ unreadMessageCount: Int, limit: Int = 300) {
            switch unreadMessageCount {
            case 0:           self = .hidden
            case 1 ... limit: self = .general(unreadMessageCount)
            default:          self = .exceededLimit(limit)
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
            case .hidden:                  return false
            case .general, .exceededLimit: return true
            }
        }
        
        func size(of font: UIFont) -> CGSize {
            text?.size(withAttributes: [.font: font]) ?? CGSize()
        }
    }
}
