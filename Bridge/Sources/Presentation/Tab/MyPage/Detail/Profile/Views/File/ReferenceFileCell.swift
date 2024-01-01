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
    // MARK: - Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
        
        contentView.flex.define { flex in
            flex.addItem(rootFlexContainer)
                .direction(.row)
                .justifyContent(.spaceBetween)
                .alignItems(.center)
                .height(52)
                .padding(17, 16, 17, 16)
                .define { flex in
                    flex.addItem(itemLabel)
                    flex.addItem(deleteButton).display(.none)
                }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: - Configuration
extension ReferenceFileCell {
    func configure(with file: ReferenceFile, isDeletable: Bool) {
        itemLabel.text = file.fileName
        deleteButton.flex.display(isDeletable ? .flex : .none)  // 삭제 버튼을 보여줄 지 결정.
    }
}
