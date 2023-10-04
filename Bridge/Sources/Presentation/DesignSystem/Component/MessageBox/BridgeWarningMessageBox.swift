//
//  BridgeWarningMessageBox.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/26.
//

import UIKit
import FlexLayout
import PinLayout

final class BridgeWarningMessageBox: BridgeMessageBox {
    
    private let warningImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "warning")?
            .resize(to: CGSize(width: 20, height: 20))
            .withRenderingMode(.alwaysTemplate)
        imageView.tintColor = BridgeColor.secondary1
        return imageView
    }()
    
    init(_ message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
    }
    
    override func configureLayouts() {
        super.configureLayouts()
        
        backgroundView.flex.define { flex in
            flex.addItem(warningImageView).size(20).marginRight(8)
            flex.addItem(messageLabel).marginRight(13)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.pin.all()
        backgroundView.flex.layout()
    }
}
