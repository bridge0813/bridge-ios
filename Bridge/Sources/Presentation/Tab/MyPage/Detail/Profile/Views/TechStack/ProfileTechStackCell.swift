//
//  ProfileTechStackCell.swift
//  Bridge
//
//  Created by 엄지호 on 12/27/23.
//

import UIKit
import FlexLayout
import PinLayout

final class ProfileTechStackCell: BaseTableViewCell {
    // MARK: - UI
    private let fieldLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        return label
    }()
    
    private let tagContainer = UIView()
    private var tags: [TechStackTag] = []
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tags.forEach { tag in
            tag.removeFromSuperview()
        }
    }
    
    // MARK: - Layout
    private func configureLayout() {
        contentView.flex.paddingHorizontal(14).define { flex in
            flex.addItem(fieldLabel).marginTop(20)
            flex.addItem(tagContainer)
                .direction(.row)
                .alignItems(.start)
                .wrap(.wrap)
                .marginTop(12)
                .marginBottom(12)
                .define { flex in
                    tags.forEach { tag in
                        flex.addItem(tag).height(38).marginRight(8).marginBottom(8)
                    }
                }
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustHeight)
        return contentView.frame.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
}

// MARK: - Configuration
extension ProfileTechStackCell {
    func configure(with fieldTeckStack: FieldTechStack) {
        let category = mapFieldToCategory(field: fieldTeckStack.field)
        let field = fieldTeckStack.field
        
        // 속성 정의
        let attributes: [String: [NSAttributedString.Key: Any]] = [
            category: [.foregroundColor: BridgeColor.gray01],
            "/": [.foregroundColor: BridgeColor.gray05],
            field: [.foregroundColor: BridgeColor.secondary1]
        ]
        let attributedString = NSMutableAttributedString(string: "\(category) / \(field)")

        // 각 부분에 속성 적용
        attributes.forEach { key, attrs in
            let range = ("\(category) / \(field)" as NSString).range(of: key)
            attributedString.addAttributes(attrs, range: range)
        }

        // 텍스트 적용
        fieldLabel.attributedText = attributedString

        // 태그버튼 생성
        let tags = fieldTeckStack.techStacks.map { tagName in
            return TechStackTag(tagName: tagName, textColor: BridgeColor.gray03)
        }
        self.tags = tags
        configureLayout()
    }
    
    private func mapFieldToCategory(field: String) -> String {
        switch field {
        case "iOS": return "개발자"
        case "안드로이드": return "개발자"
        case "프론트엔드": return "개발자"
        case "백엔드": return "개발자"
        case "UI/UX": return "디자이너"
        case "BI/BX": return "디자이너"
        case "영상/모션": return "디자이너"
        case "PM": return "기획자"
        default: return "Error"
        }
    }
}
