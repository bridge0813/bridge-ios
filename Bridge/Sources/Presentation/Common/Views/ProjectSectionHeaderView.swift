//
//  ProjectSectionHeaderView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/01.
//

import UIKit
import FlexLayout
import PinLayout

final class ProjectSectionHeaderView: BaseCollectionReusableView {
    // MARK: - Properties
    private let containerView = UIView()
    let titleLabel = UILabel()
    let decoLabel = UILabel()
    
    // MARK: - Configurations
    override func configureLayouts() {
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 27)
        
        decoLabel.textColor = .white
        decoLabel.font = .systemFont(ofSize: 15)
        decoLabel.clipsToBounds = true
        decoLabel.layer.cornerRadius = 12
        decoLabel.backgroundColor = .gray
        decoLabel.textAlignment = .center
        
        addSubview(containerView)
        containerView.flex.direction(.row).justifyContent(.start).alignItems(.center).define { flex in
            flex.addItem(titleLabel).marginLeft(10)
            flex.addItem(decoLabel).marginLeft(10).width(42).height(25)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.pin.all()
        containerView.flex.layout()
    }
}
// MARK: - Configuration
extension ProjectSectionHeaderView {
    func configureHeader(titleText: String, decoText: String) {
        titleLabel.text = titleText
        decoLabel.text = decoText
    }
}
