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
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private let messagePreviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let unreadMessagesCountLabel: UILabel = {
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
        timeLabel.text = ""
        messagePreviewLabel.text = ""
    }
    
    // MARK: - Layouts
    override func configureLayouts() {
        contentView.addSubview(chatRoomBackgroundView)
        
        let componentOffset: CGFloat = 8
        let containeroffset: CGFloat = 24
        
        chatRoomBackgroundView.flex.direction(.row).alignItems(.center).define { flex in
            flex.addItem(profileImageView).size(44).marginLeft(containeroffset)
            
            flex.addItem().direction(.column).marginHorizontal(16).define { flex in
                flex.addItem().direction(.row).marginBottom(componentOffset).define { flex in
                    flex.addItem(nameLabel).grow(1)
                    flex.addItem().size(componentOffset)
                    flex.addItem(timeLabel).shrink(1)
                }
                
                flex.addItem(messagePreviewLabel)
            }
            
            flex.addItem(unreadMessagesCountLabel).size(18).position(.absolute).right(containeroffset)
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
        nameLabel.text = chatRoom.sender
        timeLabel.text = chatRoom.time.formatted()
        messagePreviewLabel.text = chatRoom.messagePreview
    }
}
