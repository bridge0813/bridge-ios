//
//  AlertCell.swift
//  Bridge
//
//  Created by 정호윤 on 12/22/23.
//

import UIKit
import FlexLayout
import PinLayout

final class AlertCell: BaseTableViewCell {
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body1.font
        label.textColor = BridgeColor.gray01
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2Long.font
        label.textColor = BridgeColor.gray02
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.caption1.font
        label.textColor = BridgeColor.gray04
        return label
    }()
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        contentView.flex.layout()
        return contentView.frame.size
    }
    
    override func configureLayouts() {
        contentView.flex.padding(20, 16).define { flex in
            flex.addItem(titleLabel)
            flex.addItem(descriptionLabel).marginVertical(4)
            flex.addItem(dateLabel)
        }
    }
}

// MARK: - Configuration
extension AlertCell {
    func configure(with alert: BridgeAlert) {
        titleLabel.text = alert.title
        descriptionLabel.text = alert.description
        dateLabel.text = alert.date
        
        titleLabel.flex.markDirty()
        descriptionLabel.flex.markDirty()
        dateLabel.flex.markDirty()
        
        contentView.flex.layout()
    }
}
