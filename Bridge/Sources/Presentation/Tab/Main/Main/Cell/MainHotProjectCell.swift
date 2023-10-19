//
//  MainHotProjectCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/15.
//

import UIKit
import FlexLayout
import PinLayout

/// 인기 모집글을 나타내는 Cell
final class MainHotProjectCell: BaseCollectionViewCell {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private let rankingLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textAlignment = .center
        label.textColor = BridgeColor.secondary2
        label.backgroundColor = BridgeColor.secondary3
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
    
    private let scrapButton = MainBookmarkButton()
    
    // MARK: - Configure
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).height(100).alignItems(.center).define { flex in
            flex.addItem(rankingLabel).width(48).height(100).marginRight(18)
            
            flex.addItem().direction(.column).marginTop(19).marginBottom(19).define { flex in
                flex.addItem(dDayLabel).marginBottom(6)
                flex.addItem(titleLabel).width(206).height(42)
            }
            
            flex.addItem().grow(1)
            
            flex.addItem(scrapButton).size(24).marginRight(14)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    func configureCell() {
       
    }
}
