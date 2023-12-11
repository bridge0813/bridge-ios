//
//  MainBookmarkButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/18.
//

import UIKit

/// 모집글을 북마크할 수 있는 버튼(Cell에서 사용됨)
final class MainBookmarkButton: BaseButton {
    
    var isBookmarked: Bool = false {
        didSet {
            updateButtonState()
        }
    }
    
    override func configureAttributes() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = BridgeColor.gray06

        self.configuration = configuration
    }
    
    private func updateButtonState() {
        let tintColor = isBookmarked ? BridgeColor.primary1 : BridgeColor.gray06
        let imageName = isBookmarked ? "bookmark.fill" : "bookmark"
        
        let buttonImage = UIImage(named: imageName)?
            .resize(to: CGSize(width: 24, height: 24))
            .withRenderingMode(.alwaysTemplate)

        var updatedConfiguration = configuration
        updatedConfiguration?.image = buttonImage
        updatedConfiguration?.baseForegroundColor = tintColor
        configuration = updatedConfiguration
    }
}
