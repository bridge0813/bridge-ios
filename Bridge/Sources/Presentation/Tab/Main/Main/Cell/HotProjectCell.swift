//
//  MainHotProjectCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/15.
//

import UIKit
import FlexLayout
import PinLayout

/// 인기 모집글을 나타내는 Cell
final class HotProjectCell: BaseCollectionViewCell {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private let rankingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = BridgeColor.secondary2
        label.backgroundColor = BridgeColor.secondary3
        label.font = BridgeFont.headline1.font
        
        return label
    }()
    
    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.secondary1
        label.font = BridgeFont.body3.font
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.body2.font
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        
        return label
    }()
    
    private let bookmarkButton = MainBookmarkButton()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).alignItems(.center).define { flex in
            flex.addItem(rankingLabel).width(48).height(100)
            
            flex.addItem().width(206).height(62).marginLeft(18).define { flex in
                flex.addItem(dDayLabel).height(14)
                flex.addItem(titleLabel).height(42).marginTop(6)
            }
            
            flex.addItem().grow(1)
            
            flex.addItem(bookmarkButton).size(24).marginRight(14)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    func configureCell(with data: ProjectPreview) {
        titleLabel.configureTextWithLineHeight(text: data.title, lineHeight: 21)
        dDayLabel.text = "D-\(data.dDays)"
        rankingLabel.text = String(data.rank)
    }
}
