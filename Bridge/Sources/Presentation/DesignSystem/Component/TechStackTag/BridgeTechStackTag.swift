//
//  TechStackTag.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/16.
//

import UIKit
import FlexLayout
import PinLayout

/// 기술스택을 보여주는 태그
final class BridgeTechStackTag: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.tag1.font
        return label
    }()
    
    // MARK: - init
    init(tagName: String, textColor: UIColor, backgroundColor: UIColor = BridgeColor.gray09) {
        super.init(frame: .zero)
        tagLabel.text = tagName
        tagLabel.textColor = textColor
        rootFlexContainer.backgroundColor = backgroundColor
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.padding(10, 20, 10, 20).define { flex in
            flex.addItem(tagLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
