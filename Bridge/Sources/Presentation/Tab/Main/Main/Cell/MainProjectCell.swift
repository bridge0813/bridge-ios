//
//  MainProjectCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/13.
//

import UIKit
import FlexLayout
import PinLayout

final class MainProjectCell: BaseCollectionViewCell {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.configureTextWithLineHeight(text: "실제 상업용 여행사 웹사이트 \n개발할 백엔드 개발자 구합니다.", lineHeight: 24)
        label.textColor = BridgeColor.gray1
        label.font = BridgeFont.subtitle3Long.font
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
    
    private let scrapButton = MainScrapButton()
    
    private let recruitNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "1명 모집"
        label.textColor = BridgeColor.gray3
        label.font = BridgeFont.body4.font
        
        return label
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "2023.8.20 모집 마감"
        label.textColor = BridgeColor.gray3
        label.font = BridgeFont.body4.font
        
        return label
    }()
    
    // MARK: - Configure
    override func configureLayouts() {
        backgroundColor = .clear
        
        addSubview(rootFlexContainer)
        rootFlexContainer.backgroundColor = .white
        rootFlexContainer.layer.cornerRadius = 8
        rootFlexContainer.clipsToBounds = true
        
        rootFlexContainer.flex.direction(.column).height(149).define { flex in
            flex.addItem(scrapButton).position(.absolute).size(24).top(19).right(18)
            
            flex.addItem(dDayLabel).width(29).height(14).marginTop(19).marginLeft(18)
            
            flex.addItem(titleLabel).width(196).height(48).marginTop(6).marginLeft(18)
            
            flex.addItem()
                .height(1)
                .backgroundColor(BridgeColor.gray8)
                .marginHorizontal(18)
                .marginTop(24)
                .marginBottom(11.1)
            
            flex.addItem().direction(.row).alignItems(.center).define { flex in
                flex.addItem(recruitNumberLabel).width(40).height(14).marginLeft(18)
                flex.addItem(deadlineLabel).width(106).height(14).marginLeft(16)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all().marginTop(7.8).marginHorizontal(16)
        rootFlexContainer.flex.layout()
    }
    
    func configureCell() {
       
    }
}
