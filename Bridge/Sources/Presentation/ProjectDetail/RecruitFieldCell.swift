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
        view.backgroundColor = BridgeColor.gray09
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private let tagLabel = BridgeFilledChip(backgroundColor: BridgeColor.primary1, type: .short)
    
    private let fieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.gray01
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
    override func configureLayouts() {
        contentView.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.paddingLeft(14).define { flex in
            flex.addItem(tagLabel).marginTop(14)
            
            flex.addItem().direction(.row).justifyContent(.spaceBetween).marginTop(31).define { flex in
                flex.addItem().define { flex in
                    flex.addItem(fieldLabel).height(24)
                    flex.addItem(recruitNumberLabel).height(14).marginTop(4)
                }
                
                flex.addItem(emojiImageView).size(38).marginTop(8).marginRight(12)
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
extension RecruitFieldCell {
    struct FieldStyle {
        let tag: String
        let field: String
        let imageName: String
    }
    
    enum FieldType: String {
        case ios
        case android
        case frontend
        case backend
        case uiux
        case bibx
        case videomotion
        case pm
        
        var style: FieldStyle {
            switch self {
            case .ios: return FieldStyle(tag: "개발", field: "iOS", imageName: "field_ios")
            case .android: return FieldStyle(tag: "개발", field: "안드로이드", imageName: "field_android")
            case .frontend: return FieldStyle(tag: "개발", field: "프론트엔드", imageName: "field_frontend")
            case .backend: return FieldStyle(tag: "개발", field: "백엔드", imageName: "field_backend")
            case .uiux: return FieldStyle(tag: "디자인", field: "UI/UX", imageName: "field_uiux")
            case .bibx: return FieldStyle(tag: "디자인", field: "BI/BX", imageName: "field_bibx")
            case .videomotion: return FieldStyle(tag: "디자인", field: "영상/모션", imageName: "field_videomotion")
            case .pm: return FieldStyle(tag: "기획", field: "PM", imageName: "field_pm")
            }
        }
    }
    
    func configureCell(with data: MemberRequirement) {
        guard let type = FieldType(rawValue: data.field) else { return }
        
        // 분야에 맞는 text 및 이미지 설정
        tagLabel.text = type.style.tag
        fieldLabel.text = type.style.field
        emojiImageView.image = UIImage(named: type.style.imageName)
        
        // 모집인원 수 텍스트 설정.
        recruitNumberLabel.text = "\(data.recruitNumber)명 모집중"
        
        tagLabel.flex.width(tagLabel.intrinsicContentSize.width).height(22).markDirty()
    }
}
