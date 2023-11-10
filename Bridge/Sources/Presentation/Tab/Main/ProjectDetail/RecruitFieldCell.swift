//
//  RecruitFieldCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/10.
//

import UIKit
import FlexLayout
import PinLayout

/// 모집하는 분야를 나타내는 Cell
final class RecruitFieldCell: BaseCollectionViewCell {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray9
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.text = "개발"
        label.textColor = BridgeColor.gray10
        label.font = BridgeFont.caption1.font
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
          
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
