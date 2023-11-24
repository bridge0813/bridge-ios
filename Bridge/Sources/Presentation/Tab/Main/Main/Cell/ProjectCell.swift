//
//  MainProjectCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/13.
//

import UIKit
import FlexLayout
import PinLayout

/// 기본적인 모집글을 나타내는 Cell
final class ProjectCell: BaseCollectionViewCell {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.02
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1.0
        view.layer.borderColor = BridgeColor.gray08.cgColor
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.configureTextWithLineHeight(text: "실제 상업용 여행사 웹사이트 개발할 백엔드 개발자 구합니다.", lineHeight: 24)
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle3Long.font
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        
        return label
    }()
    
    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.text = "D-28"
        label.textColor = BridgeColor.secondary1
        label.font = BridgeFont.body3.font
        
        return label
    }()
    
    private let bookmarkButton = MainBookmarkButton()
    
    private let recruitNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "1명 모집"
        label.textColor = BridgeColor.gray03
        label.font = BridgeFont.body4.font
        
        return label
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "2023.8.20 모집 마감"
        label.textColor = BridgeColor.gray03
        label.font = BridgeFont.body4.font
        
        return label
    }()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.paddingHorizontal(18).define { flex in
            
            flex.addItem().direction(.row).marginTop(19).define { flex in
                flex.addItem().width(200).define { flex in
                    flex.addItem(dDayLabel)
                    flex.addItem(titleLabel).marginTop(5.8)
                }
                flex.addItem().grow(1)
                flex.addItem(bookmarkButton).size(24).marginRight(0)
            }
            
            flex.addItem().backgroundColor(BridgeColor.gray08).height(1).marginTop(24.2)
            
            flex.addItem().direction(.row).alignItems(.center).marginTop(11).define { flex in
                flex.addItem(recruitNumberLabel).height(14)
                flex.addItem(deadlineLabel).height(14).marginLeft(16)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
        
        rootFlexContainer.layer.shadowPath = UIBezierPath(
            roundedRect: rootFlexContainer.bounds,
            cornerRadius: 8
        ).cgPath
    }
    
    func configureCell() {
       
    }
}
