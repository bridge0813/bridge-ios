//
//  FilterPopUpView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/12/03.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa
 
final class FilterPopUpView: BridgeBasePopUpView {
    // MARK: - UI
    
    // MARK: - Property
    override var containerHeight: CGFloat { 576 }
    override var dismissYPosition: CGFloat { 300 }
    
    
    // MARK: - Configuration
    override func configureAttributes() {
        super.configureAttributes()
        titleLabel.text = "스택"
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(dragHandleBar).alignSelf(.center).marginTop(10)
            
            flex.addItem().backgroundColor(BridgeColor.gray08).height(1).marginTop(7)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
