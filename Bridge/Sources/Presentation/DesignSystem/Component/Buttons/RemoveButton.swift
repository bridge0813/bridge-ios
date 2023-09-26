//
//  RemoveButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/25.
//

import UIKit

final class RemoveButton: BaseButton {
    override func configureAttributes() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .default)
        let buttonImage = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        
        self.setImage(buttonImage, for: .normal)
        self.backgroundColor = .red
        self.tintColor = .white
    }
}
