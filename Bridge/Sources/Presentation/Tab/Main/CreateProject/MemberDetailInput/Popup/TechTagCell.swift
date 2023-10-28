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
    private let tagButton: BridgeFieldTagButton = {
        let button = BridgeFieldTagButton("")
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    // MARK: - Properties
    /// 버튼 자체가 Cell 크기와 동일하여 itemSelected 이벤트가 호출될 수 없기 때문에 버튼 이벤트로 대체.
    var tagButtonTapped: Observable<String> {
        return tagButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                return owner.tagButton.titleLabel?.text ?? String()
            }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()  // 재사용 셀에 대한 바인딩 초기화.
    }
    
    // MARK: - Configure
    func configureCell(with tagName: String) {
        tagButton.updateTitle(with: tagName)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        contentView.flex.define { flex in
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
