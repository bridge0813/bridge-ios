//
//  CustomDropdownCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/01.
//

import UIKit
import FlexLayout
import PinLayout

final class CustomDropdownCell: BaseTableViewCell {
    // MARK: - UI
    private let rootContainerView = UIView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(textColor: BridgeColor.gray1, font: BridgeFont.button2.font)
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    // MARK: - Layouts
    override func configureLayouts() {
        addSubview(rootContainerView)
        
        rootContainerView.flex.direction(.row).alignItems(.center).padding(10).define { flex in
            flex.addItem(titleLabel).grow(1).marginHorizontal(10)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootContainerView.pin.all()
        rootContainerView.flex.layout()
    }
}

// MARK: - Configuration
extension CustomDropdownCell {
    func configureCell() {
        
    }
}
