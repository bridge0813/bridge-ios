//
//  BaseListCell.swift
//  Bridge
//
//  Created by 엄지호 on 12/29/23.
//

import UIKit
import FlexLayout
import PinLayout

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
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray02
        return label
    }()
    
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
