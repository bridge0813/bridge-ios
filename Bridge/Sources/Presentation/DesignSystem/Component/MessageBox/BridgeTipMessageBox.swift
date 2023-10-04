//
//  BridgeTipMessageBox.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/26.
//

import UIKit
import PinLayout
import FlexLayout

final class BridgeTipMessageBox: BridgeMessageBox {
    
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "TIP"
        label.font = BridgeFont.body3.font
        label.textColor = BridgeColor.secondary1
        return label
    }()
    
    init(_ message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
    }
    
    override func configureLayouts() {
        super.configureLayouts()
        
        backgroundView.flex.define { flex in
            flex.addItem(tipLabel).marginRight(12)
            flex.addItem(messageLabel).marginRight(13)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
