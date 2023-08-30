//
//  ChatRoomTableViewCell.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa

final class ChatRoomTableViewCell: BaseTableViewCell {
    
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let profileImageView = UIImageView(image: UIImage(systemName: "person"))
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "정호윤"
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "오후 10시 10분"
        return label
    }()
    
    private let messagePreviewLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요 iOS 개발자 정호윤입니다!"
        return label
    }()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        rootFlexContainer.flex.direction(.row).padding(10).define { flex in
            flex.addItem(profileImageView).width(40).height(40).aspectRatio(1).alignSelf(.center)
            
            flex.addItem().direction(.column).grow(1).paddingLeft(10).define { flex in
                flex.addItem(nameLabel)
                flex.addItem(messagePreviewLabel)
            }
            
            flex.addItem(timeLabel).alignSelf(.center).marginLeft(10)
        }
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

// MARK: - Configuration
private extension ChatRoomTableViewCell {
    func configureCell(with chatRoom: ChatRoom) {
        nameLabel.text = chatRoom.name
        timeLabel.text = chatRoom.time.formatted()
        messagePreviewLabel.text = chatRoom.messagePreview
    }
}
