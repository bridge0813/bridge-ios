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
    var highlightTextColor: UIColor?
    var normalTextColor: UIColor?
    
    // MARK: - Layouts
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.direction(.row).alignItems(.center).padding(10).define { flex in
            flex.addItem(optionLabel).marginLeft(10).marginRight(20)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Configuration
    func configureCell() {
        
    }
    
    override var isSelected: Bool {
        willSet {
            setSelected(newValue, animated: false)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = selected ? selectedBackgroundColor : .clear
    }
}
