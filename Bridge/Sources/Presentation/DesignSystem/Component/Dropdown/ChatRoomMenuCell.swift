//
//  ChatRoomMenuCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/05.
//

import UIKit
import FlexLayout
import PinLayout

final class ChatRoomMenuCell: DropdownBaseCell {
    // MARK: - UI
    let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = BridgeColor.gray3
        imageView.image = UIImage(named: "leave")?
            .resize(to: CGSize(width: 14.43, height: 13.33))
            .withRenderingMode(.alwaysTemplate)
        
        return imageView
    }()
    
    // MARK: - Layouts
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.direction(.row).alignItems(.center).padding(10).define { flex in
            flex.addItem(optionImageView).size(20).marginRight(8)
            flex.addItem(optionLabel).marginRight(20)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    override func configureCell() {
        
    }
}
