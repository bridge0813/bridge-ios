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

/// 기술스택을 보여주는 Cell
final class TechTagCell: BaseCollectionViewCell {
    // MARK: - UI
    private let tagButton = BridgeFieldTagButton("")
    
    // MARK: - Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
        tagButton.isSelected = false 
        disposeBag = DisposeBag()  // 재사용 셀에 대한 바인딩 초기화.
    }
    
    // MARK: - Property
    private var tagName = ""
    
    var tagButtonTapped: Observable<String> {
        tagButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in owner.tagName }
    }
    

    // MARK: - Layout
    override func configureLayouts() {
        contentView.flex.define { flex in
            flex.addItem(tagButton)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.frame.size.width = size.width
        contentView.flex.layout(mode: .adjustWidth)

        return contentView.frame.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
}

extension TechTagCell {
    func configure(tagName: String, changesSelectionAsPrimaryAction: Bool = true, cornerRadius: CGFloat = 8) {
        self.tagName = tagName
        tagButton.updateTitle(with: tagName)
        tagButton.changesSelectionAsPrimaryAction = changesSelectionAsPrimaryAction
        tagButton.layer.cornerRadius = cornerRadius
        tagButton.flex.width(tagButton.intrinsicContentSize.width).height(38).markDirty()
    }
}
