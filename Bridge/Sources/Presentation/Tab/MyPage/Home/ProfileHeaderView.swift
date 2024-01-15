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
        imageView.flex.size(64).cornerRadius(32)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.headline1.font
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
                    flex.addItem(profileImageView)
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
    func configure(with viewState: MyPageViewModel.ViewState) {
        switch viewState {
        case .unauthorized:
            profileImageView.image = UIImage(named: "profile.small")
            nameLabel.text = "로그인 후 사용해주세요."
            nameLabel.textColor = BridgeColor.gray03
            manageProfileButton.flex.display(.none)
            
            
        case .authorized(let profilePreview):
            profileImageView.setImage(with: profilePreview.imageURL, size: CGSize(width: 64, height: 64))
            nameLabel.text = "\(profilePreview.name) 님"
            nameLabel.textColor = BridgeColor.gray01
            manageProfileButton.flex.display(.flex)
            updateInterestedFieldButton(subtitle: profilePreview.fields.first ?? "미설정")
            updateBookmarkedProjectButton(subtitle: "총 \(profilePreview.bookmarkedProjectCount)개")
        }
        
        nameLabel.flex.markDirty()
        manageProfileButton.flex.markDirty()
        interestedFieldButton.flex.markDirty()
        bookmarkedProjectButton.flex.markDirty()
        rootFlexContainer.flex.layout()
    }
    
    private func updateInterestedFieldButton(subtitle: String) {
        var configuration = interestedFieldButton.configuration
        configuration?.attributedSubtitle = AttributedString(
            subtitle,
            attributes: AttributeContainer([.font: BridgeFont.caption1.font, .foregroundColor: BridgeColor.primary1])
        )
        interestedFieldButton.configuration = configuration
    }
    
    private func updateBookmarkedProjectButton(subtitle: String) {
        var configuration = bookmarkedProjectButton.configuration
        configuration?.attributedSubtitle = AttributedString(
            subtitle,
            attributes: AttributeContainer([.font: BridgeFont.caption1.font, .foregroundColor: BridgeColor.primary1]))
        bookmarkedProjectButton.configuration = configuration
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
    
    var manageProfileButtonTapped: Observable<Void> {
        manageProfileButton.rx.tap.asObservable()
    }
}
