//
//  BridgeDropdownAnchorView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit
import FlexLayout
import PinLayout

final class BridgeDropdownAnchorView: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = BridgeColor.gray6.cgColor
        
        return view
    }()
    
    private let restrictionOptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.gray3
        label.font = BridgeFont.body2.font
        
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "dropdown.chevron")
            
        return imageView
    }()
    
    // MARK: - Property
    var isActive: Bool = false {
        didSet {
            updateStyleForDropdownState()
        }
    }
    
    // MARK: - Init
    init(_ defaultOption: String) {
        restrictionOptionLabel.text = defaultOption
        super.init(frame: .zero)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).alignItems(.center).define { flex in
            flex.addItem(restrictionOptionLabel).grow(1).height(18).marginLeft(16)
            flex.addItem(arrowImageView).size(24).marginRight(14)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Methods
    private func updateStyleForDropdownState() {
        let textColor = isActive ? BridgeColor.gray1 : BridgeColor.gray3
        let borderColor = isActive ? BridgeColor.primary1.cgColor : BridgeColor.gray6.cgColor
        let image: UIImage? = isActive ? UIImage(named: "dropup.chevron") : UIImage(named: "dropdown.chevron")
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            
            self.restrictionOptionLabel.textColor = textColor
            self.rootFlexContainer.layer.borderColor = borderColor
            self.arrowImageView.image = image
        }
    }
    
    func updateTitle(_ title: String) {
        restrictionOptionLabel.text = title
    }
}
