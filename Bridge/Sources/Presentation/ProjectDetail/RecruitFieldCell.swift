//
//  RecruitFieldCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/10.
//

import UIKit
import FlexLayout
import PinLayout

/// 모집하는 분야를 나타내는 Cell
final class RecruitFieldCell: BaseCollectionViewCell {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray9
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private let tagLabel = BridgeChipFillLabel(backgroundColor: BridgeColor.primary1, type: .short)
    
    private let fieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.gray1
        label.font = BridgeFont.subtitle2.font
    
        return label
    }()
    
    private let recruitNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.secondary1
        label.font = BridgeFont.body4.font
    
        return label
    }()
    
    private let emojiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Layout
    private func configureLayout() {
        contentView.addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
            flex.addItem(tagLabel).width(tagLabel.intrinsicContentSize.width).height(22).marginTop(14).marginLeft(14)
            
            flex.addItem(fieldLabel).height(24).marginTop(31).marginLeft(14)
            flex.addItem(recruitNumberLabel).height(14).marginTop(4).marginLeft(14)
            
            flex.addItem(emojiImageView).position(.absolute).size(38).bottom(14).right(12)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

// MARK: - Configuration
extension RecruitFieldCell {
    enum FieldType: String {
        case ios
        case android
        case frontend
        case backend
        case uiux
        case bibx
        case videomotion
        case pm
    }
    
    func configureCell(with data: MemberRequirement) {
        guard let field = FieldType(rawValue: data.field) else { return }
        
        // 분야에 맞는 text 및 이미지 설정
        switch field {
        case .ios:
            tagLabel.text = "개발"
            fieldLabel.text = "iOS"
            emojiImageView.image = UIImage(named: "icon_ios")
            
        case .android:
            tagLabel.text = "개발"
            fieldLabel.text = "안드로이드"
            emojiImageView.image = UIImage(named: "icon_android")
            
        case .frontend:
            tagLabel.text = "개발"
            fieldLabel.text = "프론트엔드"
            emojiImageView.image = UIImage(named: "icon_frontend")
            
        case .backend:
            tagLabel.text = "개발"
            fieldLabel.text = "백엔드"
            emojiImageView.image = UIImage(named: "icon_backend")
            
        case .uiux:
            tagLabel.text = "디자인"
            fieldLabel.text = "UI/UX"
            emojiImageView.image = UIImage(named: "icon_uiux")
            
        case .bibx:
            tagLabel.text = "디자인"
            fieldLabel.text = "BI/BX"
            emojiImageView.image = UIImage(named: "icon_bibx")
            
        case .videomotion:
            tagLabel.text = "디자인"
            fieldLabel.text = "영상/모션"
            emojiImageView.image = UIImage(named: "icon_videomotion")
            
        case .pm:
            tagLabel.text = "기획"
            fieldLabel.text = "PM"
            emojiImageView.image = UIImage(named: "icon_pm")
        }
        
        // 모집인원 수 텍스트 설정.
        recruitNumberLabel.text = "\(data.recruitNumber)명 모집중"
        
        // 라벨의 텍스트가 모두 결정되고 나서 레이아웃을 계산
        configureLayout()
    }
}
