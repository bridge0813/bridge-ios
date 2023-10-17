//
//  BridgeRemoveButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/25.
//

import UIKit

final class BridgeRemoveButton: BaseButton {
    override func configureAttributes() {
        let buttonImage = UIImage(named: "delete")?
            .resize(to: CGSize(width: 24, height: 24))
            .withRenderingMode(.alwaysTemplate)
        
        setImage(buttonImage, for: .normal)
        backgroundColor = BridgeColor.systemRed
        tintColor = BridgeColor.gray10
        layer.cornerRadius = 4
    }
}
