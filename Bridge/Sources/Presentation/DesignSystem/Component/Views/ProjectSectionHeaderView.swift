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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .black,
            font: .boldSystemFont(ofSize: 27)
        )
        return label
    }()
    
    private let supplementaryLabel: UILabel = {
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
            flex.addItem(supplementaryLabel).marginLeft(10).width(42).height(25)
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
    enum HeaderType {
        case hot
        case main
        
        var titleText: String {
            switch self {
            case .hot: return "인기 폭발 프로젝트"
            case .main: return "모집중인 프로젝트"
            }
        }
        
        var subText: String {
            switch self {
            case .hot: return "HOT"
            case .main: return "NEW"
            }
        }
    }
    
    func configureHeader(with indexPath: IndexPath) {
        let headerType: HeaderType = (indexPath.section == 0) ? .hot : .main
        titleLabel.text = headerType.titleText
        supplementaryLabel.text = headerType.subText
    }
}
