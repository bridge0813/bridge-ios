//
//  ReferenceFileCell.swift
//  Bridge
//
//  Created by 엄지호 on 12/30/23.
//

import UIKit
import FlexLayout
import PinLayout

/// 프로필에서 참고링크를 보여주는 Cell
final class ReferenceFileCell: BaseListCell {
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
extension ReferenceFileCell {
    func configure(with file: ReferenceFile) {
        itemLabel.text = file.fileName
    }
}
