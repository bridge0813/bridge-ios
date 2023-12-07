//
//  ProjectCountView.swift
//  Bridge
//
//  Created by 엄지호 on 12/6/23.
//

import UIKit
import FlexLayout
import PinLayout

/// 모집글의 갯수를 표시하는 뷰
final class ProjectCountView: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.flex.height(70)
        view.backgroundColor = BridgeColor.secondary6
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.subtitle1.font
        label.textColor = BridgeColor.secondary1
    
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.caption1.font
        label.textColor = BridgeColor.gray04
    
        return label
    }()
    
    // MARK: - Property
    var count = 0 {
        didSet {
            countLabel.text = "\(count)건"
            countLabel.flex.markDirty()
        }
    }
    
    var title = "" {
        didSet {
            titleLabel.text = title
            titleLabel.flex.markDirty()
        }
    }
    
    // MARK: - Init
    init(_ title: String) {
        titleLabel.text = title
        super.init(frame: .zero)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.padding(15, 14, 15, 14).define { flex in
            flex.addItem(countLabel)
            flex.addItem(titleLabel).marginTop(4)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all(pin.safeArea)
        rootFlexContainer.flex.layout()
    }
}
