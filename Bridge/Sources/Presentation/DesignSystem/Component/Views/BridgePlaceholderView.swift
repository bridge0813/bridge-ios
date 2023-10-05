//
//  BridgePlaceholderView.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/14.
//

import UIKit

final class BridgePlaceholderView: BaseView {
    
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
        addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension BridgePlaceholderView {
    func configurePlaceholderView(description: String?) {
        descriptionLabel.text = description
    }
}
