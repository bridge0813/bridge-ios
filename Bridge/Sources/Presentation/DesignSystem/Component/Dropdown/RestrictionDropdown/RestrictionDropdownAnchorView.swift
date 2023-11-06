//
//  RestrictionDropdownAnchorView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit
import FlexLayout
import PinLayout

final class RestrictionDropdownAnchorView: BaseView {
    private let rootFlexContainer = UIView()
    
    private let restrictionOptionLabel: UILabel = {
        let label = UILabel()
        label.text = "제한 없음"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.button2.font
        
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "dropdown.chevron")
            
        return imageView
    }()
    
    override func configureLayouts() {
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(rootFlexContainer)
        rootFlexContainer.flex
            .direction(.row)
            .justifyContent(.spaceBetween)
            .alignItems(.center)
            .padding(15)
            .define { flex in
                flex.addItem(restrictionOptionLabel).width(70).height(18)
                flex.addItem(arrowImageView).size(24).cornerRadius(10)
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    func updateViewForDropdownState(_ isActive: Bool, text: String? = nil) {
        let borderWidth: CGFloat = isActive ? 1 : 0
        let borderColor: CGColor = isActive ? BridgeColor.primary1.cgColor : UIColor.clear.cgColor
        let image: UIImage? = isActive ? UIImage(named: "dropup.chevron") : UIImage(named: "dropdown.chevron")
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layer.borderWidth = borderWidth
            self?.layer.borderColor = borderColor
            self?.arrowImageView.image = image
            
            if let text {
                self?.restrictionOptionLabel.text = text
            }
        }
    }
}
