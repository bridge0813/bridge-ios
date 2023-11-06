//
//  BridgePlaceholderView.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/14.
//

import UIKit
import FlexLayout
import PinLayout

final class BridgePlaceholderView: BaseView {
    
    private let rootFlexContainer = UIView()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray04
        label.textAlignment = .center
        return label
    }()
    
    init(description: String? = nil) {
        descriptionLabel.text = description
        super.init(frame: .zero)
    }
    
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem(descriptionLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all(pin.safeArea)
        rootFlexContainer.flex.layout()
    }
}

extension BridgePlaceholderView {
    func configurePlaceholderView(description: String?) {
        descriptionLabel.text = description
        descriptionLabel.flex.markDirty()
        rootFlexContainer.flex.layout()
    }
}
