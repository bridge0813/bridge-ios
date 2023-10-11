//
//  MenuToggleArrowButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit

final class MenuToggleArrowButton: BaseButton {
    override func configureAttributes() {
        let buttonImage = UIImage(named: "chevron.down")?
            .resize(to: CGSize(width: 15, height: 15))
            .withRenderingMode(.alwaysTemplate)
        
        var configuration = UIButton.Configuration.filled()
        configuration.image = buttonImage
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = BridgeColor.gray4
        
        self.clipsToBounds = true
        self.configuration = configuration
        self.isEnabled = true
        self.configurationUpdateHandler = { button in
            let tintColor: UIColor = button.state == .selected ? BridgeColor.primary1 : .white
            let backgroundColor: UIColor = button.state == .selected ? BridgeColor.primary3 : BridgeColor.gray5
            let rotationAngle: CGFloat = button.state == .selected ? .pi : 0.0
            
            var updatedConfiguration = button.configuration
            updatedConfiguration?.baseForegroundColor = tintColor
            updatedConfiguration?.baseBackgroundColor = backgroundColor
            button.configuration = updatedConfiguration
            
            UIView.animate(withDuration: 0.3) {
                button.transform = CGAffineTransform(rotationAngle: rotationAngle)
            }
        }
    }
}
