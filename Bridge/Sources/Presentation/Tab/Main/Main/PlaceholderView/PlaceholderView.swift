//
//  PlaceholderView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/22.
//

import UIKit
import FlexLayout
import PinLayout

/// 모집글이 없을 경우 사용되는 FooterView
final class PlaceholderView: BaseView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    let projectCountLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body4.font
        label.textColor = BridgeColor.gray3
        
        let labelText = "0개의 프로젝트"
        let attributedString = NSMutableAttributedString(string: labelText)

        if let rangeOfNumber = labelText.range(of: "0") {
            let nsRange = NSRange(rangeOfNumber, in: labelText)
            attributedString.addAttribute(.foregroundColor, value: BridgeColor.primary1, range: nsRange)
        }

        label.attributedText = attributedString
        label.isHidden = true
        
        return label
    }()
    
    private let holderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        label.textAlignment = .center
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray4
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Layout
    private func configureLayout(_ subTitleHeigth: CGFloat) {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem(projectCountLabel).position(.absolute).top(24).left(16)
            
            flex.addItem(holderImageView).size(100).marginBottom(4)
            flex.addItem(titleLabel).marginBottom(6)
            flex.addItem(subTitleLabel).width(200).height(subTitleHeigth)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

extension PlaceholderView {
    enum PlaceholderType {
        case comingSoon
        case emptyProject
        
        var image: UIImage? {
            switch self {
            case .comingSoon: return UIImage(named: "placeholder.lock")
            case .emptyProject: return UIImage(named: "placeholder.search")
            }
        }
        
        var title: String {
            switch self {
            case .comingSoon: return "출시 예정이에요!"
            case .emptyProject: return "올라온 모집글이 없어요!"
            }
        }
        
        var subTitle: String {
            switch self {
            case .comingSoon: return "빠른 시일 내에 소개할 수 있도록 \n브릿지가 노력할게요:)"
            case .emptyProject: return "조금만 기달려 주세요."
            }
        }
        
        var subTitleHeight: CGFloat {
            switch self {
            case .comingSoon: return 36
            case .emptyProject: return 21
            }
        }
    }
    
    func configureHolderView(_ type: PlaceholderType) {
        holderImageView.image = type.image
        titleLabel.text = type.title
        subTitleLabel.configureTextWithLineHeight(
            text: type.subTitle,
            lineHeight: 18,
            alignment: .center
        )

        configureLayout(type.subTitleHeight)
    }
}
