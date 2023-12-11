//
//  MenuCell.swift
//  Bridge
//
//  Created by 정호윤 on 11/9/23.
//

import UIKit
import FlexLayout
import PinLayout

final class MenuCell: BaseTableViewCell {
    // MARK: - UI
    private let menuLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.subtitle3.font
        label.textColor = BridgeColor.gray02
        return label
    }()
    
    // MARK: - Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
        menuLabel.text = nil
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        contentView.flex.direction(.row).paddingHorizontal(16).define { flex in
            flex.addItem(menuLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
}

// MARK: - Configuration
extension MenuCell {
    func configure(with menu: String) {
        menuLabel.text = menu
    }
}
