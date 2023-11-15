//
//  RecruitFieldDetailCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/12.
//

import UIKit
import FlexLayout
import PinLayout

/// 모집하는 분야에 대한 요구사항을 자세하게 나타내는 Cell
final class RecruitFieldDetailCell: BaseCollectionViewCell {
    // MARK: - UI
    private let blueContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.secondary6
        
        return view
    }()
    
    private let tagLabel = BridgeFilledChip(backgroundColor: BridgeColor.primary1, type: .short)
    
    private let flexContainer = UIView()  // Cell의 재사용에 대응하기 위한 명시적 컨테이너
    
    private let fieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle1.font
    
        return label
    }()
    
    private let recruitNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.secondary1
        label.font = BridgeFont.caption1.font
    
        return label
    }()
    
    private let requirementTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "바라는 점"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.body1.font
    
        return label
    }()
    
    private let requirementLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.gray02
        label.font = BridgeFont.body2.font
        label.numberOfLines = 0
        
        return label
    }()
    
    private let dividerView: UIView = {  // Cell의 재사용에 대응하기 위한 명시적 구분선
        let view = UIView()
        view.backgroundColor = BridgeColor.gray08
        
        return view
    }()
    
    private let techStackLabel: UILabel = {
        let label = UILabel()
        label.text = "스택"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.body2.font
    
        return label
    }()
    
    private let tagContainer = UIView()
    private var tagButtons: [BridgeFieldTagButton] = []
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tagButtons.forEach { button in
            button.removeFromSuperview()
        }
    }

    // MARK: - Configuration
    override func configureAttributes() {
        contentView.backgroundColor = BridgeColor.gray10
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = BridgeColor.gray08.cgColor
        contentView.clipsToBounds = true
    }
    
    // MARK: - Layout
    private func configureLayout() {
        contentView.flex.define { flex in
            flex.addItem(blueContainer).height(95).paddingLeft(16).define { flex in
                flex.addItem(tagLabel).width(tagLabel.intrinsicContentSize.width).height(22).marginTop(24)
                
                flex.addItem(flexContainer)
                    .direction(.row)
                    .justifyContent(.spaceBetween)
                    .alignItems(.center)
                    .height(22)
                    .marginTop(15)
                    .define { flex in
                        flex.addItem(fieldLabel)
                        flex.addItem(recruitNumberLabel).height(14).marginRight(18)
                    }
            }
            
            flex.addItem(requirementTitleLabel).width(52).height(18).marginTop(20).marginLeft(16)
            flex.addItem(requirementLabel).marginTop(12).marginHorizontal(16)
            
            flex.addItem(dividerView).height(1).marginTop(14).marginHorizontal(16)
            
            flex.addItem(techStackLabel).width(25).height(18).marginTop(14).marginLeft(16)
            
            flex.addItem(tagContainer)
                .direction(.row)
                .alignItems(.start)
                .wrap(.wrap)
                .marginTop(12)
                .marginHorizontal(16)
                .marginBottom(20)
                .define { flex in
                    tagButtons.forEach { button in
                        flex.addItem(button).height(38).marginRight(8).marginBottom(8)
                    }
                }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.top().left(16).bottom(12).right(16)
        contentView.flex.layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.top().left(16).bottom(12).right(16)
        contentView.flex.layout(mode: .adjustHeight)

        return contentView.frame.size
    }
}

// MARK: - Configuration
extension RecruitFieldDetailCell {
    struct FieldStyle {
        let tag: String
        let field: String
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
            case .ios: return FieldStyle(tag: "개발", field: "iOS")
            case .android: return FieldStyle(tag: "개발", field: "안드로이드")
            case .frontend: return FieldStyle(tag: "개발", field: "프론트엔드")
            case .backend: return FieldStyle(tag: "개발", field: "백엔드")
            case .uiux: return FieldStyle(tag: "디자인", field: "UI/UX")
            case .bibx: return FieldStyle(tag: "디자인", field: "BI/BX")
            case .videomotion: return FieldStyle(tag: "디자인", field: "영상/모션")
            case .pm: return FieldStyle(tag: "기획", field: "PM")
            }
        }
    }
    
    func configureCell(with data: MemberRequirement) {
        guard let type = FieldType(rawValue: data.field) else { return }
        
        // 분야에 맞는 텍스트 설정.
        tagLabel.text = type.style.tag
        fieldLabel.text = type.style.field
        
        // 모집인원 수 텍스트 설정.
        recruitNumberLabel.text = "\(data.recruitNumber)명 모집중"
        
        // 바라는 점 텍스트 설정.
        requirementLabel.text = data.requirementText
        
        // 태그버튼 생성
        let buttons = data.requiredSkills.map { title in
            let button = BridgeFieldTagButton(title)
            button.changesSelectionAsPrimaryAction = false
            
            return button
        }
        tagButtons = buttons
        
        configureLayout()
    }
}
