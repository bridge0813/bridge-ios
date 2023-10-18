//
//  BridgeMessageBox.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/26.
//

import UIKit
import FlexLayout
import PinLayout

class BridgeMessageBox: BaseView {
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.secondary6
        view.layer.cornerRadius = 4
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.caption1.font
        label.textColor = BridgeColor.gray2
        label.textAlignment = .left
        return label
    }()
    
    override func configureLayouts() {
        addSubview(backgroundView)
        backgroundView.flex.direction(.row).padding(13).height(38)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.pin.all()
        backgroundView.flex.layout()
    }
}
