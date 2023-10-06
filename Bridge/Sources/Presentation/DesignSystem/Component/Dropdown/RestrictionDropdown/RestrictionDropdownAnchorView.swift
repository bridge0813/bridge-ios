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
    
    private let restrictionTypeLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .black,
            font: .boldSystemFont(ofSize: 14)
        )
        label.text = "학생"
        
        return label
    }()
    
    // 디자인시스템에 명시된 대로 사이즈를 지정하면 해상도도 이상하고, 이미지 크기가 조정이 안됨.
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = BridgeColor.gray5
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "chevron.down")?
            .resize(to: CGSize(width: 6, height: 5))
            .withRenderingMode(.alwaysTemplate)
        
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
            .padding(10)
            .define { flex in
                flex.addItem(restrictionTypeLabel).width(40).marginLeft(5)
                flex.addItem(arrowImageView).size(20).cornerRadius(10).marginRight(5)
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    func updateViewForDropdownState(_ isActive: Bool, text: String? = nil) {
        let rotationAngle: CGFloat = isActive ? .pi : 0.0
        let borderWidth: CGFloat = isActive ? 1 : 0
        let borderColor: CGColor = isActive ? BridgeColor.primary1.cgColor : UIColor.clear.cgColor
        let arrowBackgroundColor: UIColor = isActive ? BridgeColor.primary3 : BridgeColor.gray5
        let arrowTintColor: UIColor = isActive ? BridgeColor.primary1 : .white
        
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.arrowImageView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            self?.layer.borderWidth = borderWidth
            self?.layer.borderColor = borderColor
            self?.arrowImageView.backgroundColor = arrowBackgroundColor
            self?.arrowImageView.tintColor = arrowTintColor
            
            if let text {
                self?.restrictionTypeLabel.text = text
            }
        }
    }
}
