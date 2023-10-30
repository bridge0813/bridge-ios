//
//  BaseDropdownCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/05.
//

import UIKit
import FlexLayout
import PinLayout

class BaseDropdownCell: BaseTableViewCell {
    // MARK: - UI
    static let identifier = "DropDownCell"
    
    let rootFlexContainer = UIView()
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.gray1
        label.font = BridgeFont.button2.font
        
        return label
    }()
    
    var selectedBackgroundColor: UIColor?
    var selectedTextColor: UIColor?
    var nomalTextColor: UIColor?
    
    // MARK: - Layouts
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.direction(.row).alignItems(.center).define { flex in
            flex.addItem(optionLabel).marginHorizontal(16)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Configuration
    override var isSelected: Bool {
        willSet {
            setSelected(newValue, animated: false)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = selected ? selectedBackgroundColor : .clear
        optionLabel.textColor = selected ? selectedTextColor : nomalTextColor
    }
}
