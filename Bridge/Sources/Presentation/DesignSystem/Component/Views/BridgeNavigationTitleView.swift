//
//  BridgeNavigationTitleView.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/30.
//

import UIKit

final class BridgeNavigationTitleView: BaseView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    override var intrinsicContentSize: CGSize {
        UIView.layoutFittingExpandedSize
    }
    
    init(title: String) {
        titleLabel.text = title
        super.init(frame: .zero)
    }
    
    override func configureLayouts() {
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
