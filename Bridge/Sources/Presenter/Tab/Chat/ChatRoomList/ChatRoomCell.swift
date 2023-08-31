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
import RxSwift

final class ChatRoomCell: BaseTableViewCell {
    
    // MARK: - UI
    private let chatRoomBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "정호윤"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "오후 10시 10분"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private let messagePreviewLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요 iOS 개발자 정호윤입니다!"
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
        label.clipsToBounds = true
        return label
    }()
    
    func bind(_ chatRoom: Driver<ChatRoom>) {
        chatRoom
            .drive { [weak self] chatRoom in self?.configureCell(with: chatRoom) }
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = nil
        nameLabel.text = ""
        timeLabel.text = ""
        messagePreviewLabel.text = ""
        disposeBag = DisposeBag()
    }
    
    // MARK: - Configurations
    override func configureLayouts() {
        contentView.addSubview(chatRoomBackgroundView)
        
        let padding: CGFloat = 24
        let margin: CGFloat = 8
        
        chatRoomBackgroundView.flex.direction(.row).padding(padding).alignItems(.center).define { flex in
            flex.addItem(profileImageView).size(44).cornerRadius(22).aspectRatio(1)
            
            flex.addItem().direction(.column).width(200).marginHorizontal(margin * 2).define { flex in
                flex.addItem().direction(.row).marginBottom(margin).define { flex in
                    flex.addItem(nameLabel)
                    flex.addItem(timeLabel).marginLeft(margin)
                }
                
                flex.addItem(messagePreviewLabel)
            }
            
            flex.addItem(unreadMessagesCountLabel).size(18).cornerRadius(9)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let offset: CGFloat = 16
        chatRoomBackgroundView.pin.top(offset).left(offset).right(offset).bottom()
        chatRoomBackgroundView.flex.layout()
    }
}

// MARK: - Configuration
private extension ChatRoomCell {
    func configureCell(with chatRoom: ChatRoom) {
        nameLabel.text = chatRoom.name
        timeLabel.text = chatRoom.time.formatted()
        messagePreviewLabel.text = chatRoom.messagePreview
    }
}
