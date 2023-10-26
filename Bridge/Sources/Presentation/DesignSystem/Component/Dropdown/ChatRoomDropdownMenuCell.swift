//
//  ChatRoomDropdownMenuCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/05.
//

import UIKit
import FlexLayout
import PinLayout

final class ChatRoomDropdownMenuCell: BaseDropdownCell {
    // MARK: - UI
    private lazy var optionimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = BridgeColor.gray3
        return imageView
    }()
    
    // MARK: - Layouts
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.direction(.row).alignItems(.center).padding(10, 16).define { flex in
            flex.addItem(optionimageView).size(20).marginRight(8)
            flex.addItem(optionLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

// MARK: - Configuration
extension ChatRoomDropdownMenuCell {
    func configure(image: UIImage?) {
        optionimageView.image = image?.resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
    }
}
