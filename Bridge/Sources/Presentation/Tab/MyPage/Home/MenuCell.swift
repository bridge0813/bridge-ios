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
    
    // MARK: - Layout
    override func configureLayouts() {
        contentView.flex.paddingHorizontal(16).define { flex in
            flex.addItem(menuLabel).grow(1)
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
