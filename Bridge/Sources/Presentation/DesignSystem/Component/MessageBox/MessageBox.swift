//
//  MessageBox.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/26.
//

import UIKit
import FlexLayout
import PinLayout

class MessageBox: BaseView {
    // MARK: - UI
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.secondary4
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
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(backgroundView)
        
        backgroundView.flex
            .direction(.row)
            .justifyContent(.start)
            .alignItems(.center)
            .width(343)
            .height(38)
            .padding(13)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.pin.all()
        backgroundView.flex.layout()
    }
}
