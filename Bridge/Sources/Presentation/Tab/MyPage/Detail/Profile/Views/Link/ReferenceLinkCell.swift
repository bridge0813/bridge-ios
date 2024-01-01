//
//  ProfileListCell.swift
//  Bridge
//
//  Created by 엄지호 on 12/29/23.
//

import UIKit
import FlexLayout
import PinLayout

/// 프로필에서 참고링크를 보여주는 Cell
final class ReferenceLinkCell: BaseListCell {
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
        
        contentView.flex.define { flex in
            flex.addItem(rootFlexContainer).height(52).padding(17, 16, 17, 16).define { flex in
                flex.addItem(itemLabel)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: - Configuration
extension ReferenceLinkCell {
    func configure(with urlString: String) {
        itemLabel.text = urlString
    }
}