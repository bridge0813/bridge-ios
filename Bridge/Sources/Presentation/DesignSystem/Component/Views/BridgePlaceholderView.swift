//
//  BridgePlaceholderView.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/14.
//

import UIKit
import FlexLayout
import PinLayout

final class BridgePlaceholderView: BaseView {
    
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray09
        return view
    }()
    
    private let emojiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray04
        label.textAlignment = .center
        return label
    }()
    
    init(description: String? = nil) {
        descriptionLabel.text = description
        super.init(frame: .zero)
    }
    
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem(emojiImageView).size(100)
            flex.addItem(titleLabel).marginTop(4)
            flex.addItem(descriptionLabel).marginTop(6)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all(pin.safeArea)
        rootFlexContainer.flex.layout()
    }
}

extension BridgePlaceholderView {
     enum PlaceholderType {
        case needSignIn
         case error
        case emptyChatRoom
    }
    
    func configurePlaceholderView(for type: PlaceholderType) {
        switch type {
        case .needSignIn:
            emojiImageView.image = UIImage(named: "graphic_signIn")
            titleLabel.text = "로그인 후 사용가능해요!"
            descriptionLabel.text = "로그인 후 사용 가능한 기능입니다."
            
        case .error:
            emojiImageView.image = UIImage(named: "graphic_warning")
            titleLabel.text = "오류가 발생했습니다."
            descriptionLabel.text = "잠시 후 다시 시도해 주세요."
            
        case .emptyChatRoom:
            emojiImageView.image = UIImage(named: "graphic_chat")
            titleLabel.text = "현재 채팅이 없어요!"
            descriptionLabel.text = "예비 팀원과 새로운 채팅을 시작해보세요."
        }

        emojiImageView.flex.markDirty()
        titleLabel.flex.markDirty()
        descriptionLabel.flex.markDirty()
        rootFlexContainer.flex.layout()
    }
}
