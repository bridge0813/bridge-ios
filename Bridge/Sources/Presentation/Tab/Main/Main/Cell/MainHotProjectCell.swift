//
//  MainHotProjectCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/15.
//

import UIKit
import FlexLayout
import PinLayout

final class MainHotProjectCell: BaseCollectionViewCell {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let rankingLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textAlignment = .center
        label.textColor = BridgeColor.hotCellRankingTextColor
        label.backgroundColor = BridgeColor.hotCellRankingBackgroundColor
        label.font = BridgeFont.headline1.font
        
        return label
    }()
    
    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.text = "D-24"
        label.textColor = BridgeColor.secondary1
        label.font = BridgeFont.body3.font
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.configureTextWithLineHeight(text: "사이드 프젝으로 IOS앱을 같이 구현할 \n팀원을 구하고 있어요~", lineHeight: 21)
        label.textColor = BridgeColor.gray1
        label.font = BridgeFont.body2.font
        label.numberOfLines = 2
        
        return label
    }()
    
    private let scrapButton = MainScrapButton()
    
    // MARK: - Configure
    override func configureLayouts() {
        backgroundColor = .clear
        
        addSubview(rootFlexContainer)
        rootFlexContainer.backgroundColor = .white
        rootFlexContainer.layer.cornerRadius = 8
        rootFlexContainer.clipsToBounds = true
        
        rootFlexContainer.flex.direction(.row).height(100).alignItems(.center).define { flex in
            flex.addItem(rankingLabel).width(48).height(100).marginRight(18)
            
            flex.addItem().direction(.column).marginTop(18.8).marginBottom(19.2).define { flex in
                flex.addItem(dDayLabel).width(29).height(14).marginBottom(6)
                flex.addItem(titleLabel).width(206).height(42)
            }
            
            flex.addItem().grow(1)
            
            flex.addItem(scrapButton).size(24).marginRight(14)
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
