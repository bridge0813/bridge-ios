//
//  ProfileHeaderView.swift
//  Bridge
//
//  Created by 정호윤 on 11/10/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift

final class ProfileHeaderView: BaseView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile.small")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // TODO: 로그인 여부에 따라 바뀌어야하므로 기본값 뭐로 할지 결정 (없애던가)
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "홍길동"
        label.font = BridgeFont.headline1.font
        label.textColor = BridgeColor.gray01
        return label
    }()
    
    private let manageProfileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = BridgeColor.primary2
        button.setTitle("프로필 관리", for: .normal)
        button.titleLabel?.font = BridgeFont.caption1.font
        button.setTitleColor(BridgeColor.primary1, for: .normal)
        return button
    }()
    
    private let interestedMenuBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = BridgeColor.gray07.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.02
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 5
        return view
    }()
    
    private let interestedFieldButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(
            "관심분야",
            attributes: AttributeContainer([.font: BridgeFont.body1.font, .foregroundColor: BridgeColor.gray01])
        )
        configuration.attributedSubtitle = AttributedString(
            "미설정",
            attributes: AttributeContainer([.font: BridgeFont.caption1.font, .foregroundColor: BridgeColor.primary1])
        )
        configuration.titleAlignment = .leading
        configuration.titlePadding = 3
        configuration.image = UIImage(named: "graphic_check")?.resize(to: CGSize(width: 34, height: 34))
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 48
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return UIButton(configuration: configuration)
    }()
    
    private let bookmarkedProjectButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(
            "관심공고",
            attributes: AttributeContainer([.font: BridgeFont.body1.font, .foregroundColor: BridgeColor.gray01])
        )
        configuration.attributedSubtitle = AttributedString(
            "총 0개",
            attributes: AttributeContainer([.font: BridgeFont.caption1.font, .foregroundColor: BridgeColor.primary1])
        )
        configuration.titleAlignment = .leading
        configuration.titlePadding = 3
        configuration.image = UIImage(named: "graphic_files")?.resize(to: CGSize(width: 34, height: 34))
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 48
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return UIButton(configuration: configuration)
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        interestedMenuBackgroundView.layer.shadowPath = UIBezierPath(
            roundedRect: interestedMenuBackgroundView.bounds,
            cornerRadius: 8
        ).cgPath
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem().height(185).paddingHorizontal(16).backgroundColor(BridgeColor.primary3).define { flex in
                flex.addItem().direction(.row).alignItems(.center).marginTop(40).marginBottom(18).define { flex in
                    flex.addItem(profileImageView).size(64).cornerRadius(32)
                    flex.addItem(nameLabel).marginLeft(18)
                    flex.addItem().grow(1)
                    flex.addItem(manageProfileButton).width(83).height(30).cornerRadius(15)
                }
                
                flex.addItem(interestedMenuBackgroundView)
                    .direction(.row)
                    .justifyContent(.spaceBetween)
                    .height(83)
                    .padding(24, 20)
                    .define { flex in
                        flex.addItem(interestedFieldButton)
                        flex.addItem(bookmarkedProjectButton)
                    }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

// MARK: - Configuration
extension ProfileHeaderView {
    func configure() {
        
    }
}

// MARK: - Observable
extension ProfileHeaderView {
    var interestedFieldButtonTapped: Observable<Void> {
        interestedFieldButton.rx.tap.asObservable()
    }
    
    var bookmarkedProjectButtonTapped: Observable<Void> {
        bookmarkedProjectButton.rx.tap.asObservable()
    }
}
