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
        label.text = "1"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.cornerRadius = 9
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
            
            flex.addItem(unreadMessageCountLabel).size(18).position(.absolute).right(containerOffset)
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
    }
}
