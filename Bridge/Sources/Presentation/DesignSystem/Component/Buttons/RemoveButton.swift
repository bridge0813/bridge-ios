//
//  RemoveButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/25.
//

import UIKit

final class RemoveButton: BaseButton {
    override func configureAttributes() {
        let buttonImage = UIImage(named: "delete")?
            .resize(to: CGSize(width: 24, height: 24))
            .withRenderingMode(.alwaysTemplate)
        
        self.setImage(buttonImage, for: .normal)
        self.backgroundColor = BridgeColor.systemRed
        self.tintColor = BridgeColor.gray10
        self.layer.cornerRadius = 4
    }
}
