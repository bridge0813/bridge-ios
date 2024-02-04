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
    private let categoryLabel = BridgeFilledChip(backgroundColor: BridgeColor.primary1, type: .short)
    
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
    
    // MARK: - Configuration
    override func configureAttributes() {
        contentView.backgroundColor = BridgeColor.gray09
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        contentView.flex.paddingLeft(14).define { flex in
            flex.addItem(categoryLabel).marginTop(14)
            
            flex.addItem().direction(.row).justifyContent(.spaceBetween).marginTop(31).define { flex in
                flex.addItem().grow(1).define { flex in
                    flex.addItem(fieldLabel).height(24)
                    flex.addItem(recruitNumberLabel).height(14).marginTop(4)
                }
                
                flex.addItem(emojiImageView).size(38).marginTop(8).marginRight(12)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
}

// MARK: - Configuration
extension RecruitFieldCell {
    func configureCell(with data: MemberRequirement) {
        // 분야에 맞는 text 및 이미지 설정
        categoryLabel.text = data.field.categoryForField()
        fieldLabel.text = data.field
        emojiImageView.image = image(forField: data.field)
        
        // 모집인원 수 텍스트 설정.
        recruitNumberLabel.text = "\(data.recruitNumber)명 모집중"
        
        categoryLabel.flex.width(categoryLabel.intrinsicContentSize.width).height(22).markDirty()
    }
    
    /// 분야에 맞는 이미지 반환
    private func image(forField field: String) -> UIImage? {
        switch field {
        case "iOS": return UIImage(named: "field_ios")
        case "안드로이드": return UIImage(named: "field_android")
        case "프론트엔드": return UIImage(named: "field_frontend")
        case "백엔드": return UIImage(named: "field_backend")
        case "UI/UX": return UIImage(named: "field_uiux")
        case "BI/BX": return UIImage(named: "field_bibx")
        case "영상/모션": return UIImage(named: "field_videomotion")
        case "PM": return UIImage(named: "field_pm")
        default: return nil
        }
    }
}
