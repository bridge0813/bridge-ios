//
//  AddedTechTagView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/25.
//

import UIKit
import FlexLayout
import PinLayout

/// 팀원에 대한 스택을 추가하면, 추가된 스택에 맞게 tag로 보여주는  뷰
final class AddedTechTagView: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray9
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.height(52).define { flex in
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
