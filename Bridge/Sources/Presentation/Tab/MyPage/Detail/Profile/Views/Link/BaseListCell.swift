//
//  BaseListCell.swift
//  Bridge
//
//  Created by 엄지호 on 12/29/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift

/// 프로필에서 리스트(링크, 파일 등)를 보여주는 BaseCell
class BaseListCell: BaseTableViewCell {
    // MARK: - UI
    let rootFlexContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = BridgeColor.gray06.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let itemLabel: UILabel = {
        let label = UILabel()
        label.flex.width(230).height(18)
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray02
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.flex.size(20)
        button.setImage(
            UIImage(named: "delete.circle")?
                .resize(to: CGSize(width: 20, height: 20))
                .withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.tintColor = BridgeColor.gray04
        return button
    }()
    
    // MARK: - Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        contentView.addSubview(rootFlexContainer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
}
