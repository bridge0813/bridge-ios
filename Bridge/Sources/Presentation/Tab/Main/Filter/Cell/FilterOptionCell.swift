//
//  FilterOptionCell.swift
//  Bridge
//
//  Created by 엄지호 on 2/5/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 필터 옵션 태그 Cell
final class FilterOptionCell: BaseCollectionViewCell {
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.tag1.font
        label.textColor = BridgeColor.primary1
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.flex.size(18)
        button.setImage(
            UIImage(named: "xmark")?.resize(to: CGSize(width: 18, height: 18)).withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.tintColor = BridgeColor.primary1
        
        return button
    }()

    
    // MARK: - Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()  // 재사용 셀에 대한 바인딩 초기화.
    }
    
    // MARK: - Property
    var deleteButtonTapped: Observable<String> {
        return deleteButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in owner.titleLabel.text ?? "" }
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        contentView.layer.borderColor = BridgeColor.primary1.cgColor
        contentView.layer.borderWidth = 1.5
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        contentView.flex.direction(.row).alignItems(.center).padding(10, 20, 10, 20).define { flex in
            flex.addItem(titleLabel)
            flex.addItem(deleteButton).marginLeft(2)
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

extension FilterOptionCell {
    func configure(with optionName: String) {
        titleLabel.text = optionName
        titleLabel.flex.markDirty()
    }
}
