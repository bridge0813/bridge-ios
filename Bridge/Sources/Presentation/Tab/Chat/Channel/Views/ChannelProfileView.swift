//
//  ChannelProfileView.swift
//  Bridge
//
//  Created by 엄지호 on 1/15/24.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift

final class ChannelProfileView: BaseView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.flex.size(28).cornerRadius(14)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(BridgeColor.gray01, for: .normal)
        button.titleLabel?.font = BridgeFont.subtitle2.font
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        return button
    }()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).alignItems(.center).define { flex in
            flex.addItem(imageView)
            flex.addItem(nameButton).marginLeft(8)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

// MARK: - Configure
extension ChannelProfileView {
    func configure(with channel: Channel) {
        nameButton.setTitle(channel.name, for: .normal)
        imageView.setImage(
            from: channel.imageURL,
            size: CGSize(width: 28, height: 28),
            placeholderImage: UIImage(named: "profile")
        )
    }
}

// MARK: - Observable
extension ChannelProfileView {
    var nameButtonTapped: Observable<Void> {
        nameButton.rx.tap.asObservable()
    }
}
