//
//  TechTagCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/27.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 기본적인 모집글을 나타내는 Cell
final class TechTagCell: BaseCollectionViewCell {
    // MARK: - UI
    let tagButton = BridgeFieldTagButton("")
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()  // 재사용 셀에 대한 바인딩 초기화.
    }

    // MARK: - Layout
    func configureLayout() {
        contentView.flex.width(tagButton.intrinsicContentSize.width).define { flex in
            flex.addItem(tagButton)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.bounds.size.width = size.width
        contentView.flex.layout(mode: .adjustWidth)

        return contentView.frame.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
}
