//
//  ApplicantCell.swift
//  Bridge
//
//  Created by 엄지호 on 12/12/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

final class ApplicantCell: BaseCollectionViewCell {
    // MARK: - UI
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.flex.size(44).cornerRadius(22)
        imageView.backgroundColor = BridgeColor.gray06
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(BridgeColor.gray01, for: .normal)
        button.titleLabel?.font = BridgeFont.subtitle1.font
        return button
    }()
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.secondary1
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    private let menuButtonGroup: BridgeMediumButtonGroup = {
        let buttonGroup = BridgeMediumButtonGroup(("채팅하기", "수락하기", "거절하기"))
        buttonGroup.flex.width(100%).height(48)
        
        return buttonGroup
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Property
    private var applicantProfile = ApplicantProfile(userID: 0, imageURL: "", name: "", fields: [], career: "")
    
    var nameButtonTapped: Observable<ApplicantID> {
        return nameButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                return owner.applicantProfile.userID
            }
    }
    
    /// 지원자 목록 or 프로젝트 상세
    var buttonGroupTapped: Observable<(String, ApplicantProfile)> {
        return menuButtonGroup.buttonGroupTapped
            .withUnretained(self)
            .map { owner, title in
                return (title, owner.applicantProfile)
            }
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.03
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 4
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = BridgeColor.gray08.cgColor
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = false
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        contentView.flex.padding(24, 18, 18, 18).define { flex in
            flex.addItem().direction(.row).height(44).define { flex in
                flex.addItem(profileImageView)
                
                flex.addItem().grow(1).marginLeft(16).define { flex in
                    flex.addItem(nameButton)
                    flex.addItem(informationLabel).marginTop(4)
                }
            }
            
            flex.addItem(menuButtonGroup).marginTop(16)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
        
        contentView.layer.shadowPath = UIBezierPath(
            roundedRect: contentView.bounds,
            cornerRadius: 8
        ).cgPath
    }
}

extension ApplicantCell {
    func configureCell(with data: ApplicantProfile) {
        profileImageView.setImage(from: data.imageURL, size: CGSize(width: 44, height: 44), placeholderImage: nil)
        
        let fieldsText = data.fields.joined(separator: ", ")
        
        // 설정해둔 직업이 있으면 보여주기.
        if let career = data.career {
            informationLabel.text = "\(career), \(fieldsText)"
        } else {
            informationLabel.text = fieldsText
        }
        
        nameButton.setTitle(data.name, for: .normal)
        nameButton.flex.width(nameButton.intrinsicContentSize.width).height(22).markDirty()
        applicantProfile = data
    }
}
