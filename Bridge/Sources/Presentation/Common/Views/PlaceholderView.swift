//
//  PlaceholderView.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/14.
//

import UIKit
import FlexLayout
import PinLayout

final class PlaceholderView: BaseView {
    
    private let rootFlexContainer = UIView()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    init(description: String? = nil) {
        descriptionLabel.text = description
        super.init(frame: .zero)
    }
    
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.direction(.column).justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem(descriptionLabel).margin(10)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

extension PlaceholderView {
    func configurePlaceholderView(description: String?) {
        descriptionLabel.text = description
    }
}
