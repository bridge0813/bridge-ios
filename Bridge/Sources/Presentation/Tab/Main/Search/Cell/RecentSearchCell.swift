//
//  RecentSearchCell.swift
//  Bridge
//
//  Created by 엄지호 on 2/6/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift

final class RecentSearchCell: BaseTableViewCell {
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray02
        return label
    }()
    
    // MARK: - Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Property
    
    // MARK: - Layout
    override func configureLayouts() {
        contentView.flex.direction(.row).justifyContent(.spaceBetween).alignItems(.center).define { flex in
            flex.addItem(titleLabel).grow(1).height(18)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
}

// MARK: - Configuration
extension RecentSearchCell {
    func configure(with data: RecentSearch) {
        titleLabel.text = data.searchWord
    }
}
