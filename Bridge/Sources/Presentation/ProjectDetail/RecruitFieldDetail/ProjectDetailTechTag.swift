//
//  ProjectDetailTechTag.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/16.
//

import UIKit
import FlexLayout
import PinLayout

final class ProjectDetailTechTag: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray09
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.gray02
        label.font = BridgeFont.tag1.font
        
        return label
    }()
    
    // MARK: - init
    init(_ tagName: String) {
        super.init(frame: .zero)
        tagLabel.text = tagName
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.padding(10, 20, 10, 20).define { flex in
            flex.addItem(tagLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
