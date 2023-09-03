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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .black,
            font: .boldSystemFont(ofSize: 27)
        )
        return label
    }()
    
    let decoLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .white,
            font: .systemFont(ofSize: 15),
            textAlignment: .center
        )
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.backgroundColor = .gray
        
        return label
    }()
    
    // MARK: - Configurations
    override func configureLayouts() {
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
