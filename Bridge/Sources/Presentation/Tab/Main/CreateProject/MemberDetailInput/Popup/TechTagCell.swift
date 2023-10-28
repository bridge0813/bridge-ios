//
//  TechTagCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/27.
//

import UIKit
import FlexLayout
import PinLayout

/// 기본적인 모집글을 나타내는 Cell
final class TechTagCell: BaseCollectionViewCell {
    // MARK: - UI
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = BridgeColor.gray3
        label.font = BridgeFont.tag1.font
        label.textAlignment = .center
        
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - Configure
    override func configureAttributes() {
        contentView.backgroundColor = BridgeColor.gray9
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 4
        contentView.layer.borderWidth = .zero
        contentView.layer.borderColor = BridgeColor.primary1.cgColor
    }
    
    func configureCell(with tagName: String) {
        tagLabel.text = tagName
    }
    
    /// Cell의 선택에 따라 반전(이미 선택된 셀은 원상복구)
    func updateCellStyle(with isSelected: Bool) {
        let textColor = isSelected ? BridgeColor.primary1 : BridgeColor.gray3
        let backgroundColor = isSelected ? BridgeColor.gray10 : BridgeColor.gray9
        let borderWidth: CGFloat = isSelected ? 1 : 0
        
        tagLabel.textColor = textColor
        contentView.backgroundColor = backgroundColor
        contentView.layer.borderWidth = borderWidth
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        contentView.flex.padding(10, 20, 10, 20).define { flex in
            flex.addItem(tagLabel)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.bounds.size.width = size.width
        contentView.flex.layout(mode: .adjustWidth)

        return contentView.frame.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
}
