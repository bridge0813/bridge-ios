//
//  AddTechStackButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/24.
//

import UIKit
import FlexLayout

/// 특정 컨텐츠(기술 스택, 링크, 파일 등)를 추가하는 버튼(isAdded를 통해 타이틀 수정도 가능)
final class BridgeAddButton: BaseButton {
    // MARK: - Property
    /// 추가된 컨텐츠가 있을 경우를 나타내는 프로퍼티
    var isAdded: Bool = false {
        didSet {
            updateButtonConfiguration()
        }
    }
    
    private var titleFont: UIFont
    
    // MARK: - Init
    init(titleFont: UIFont) {
        self.titleFont = titleFont
        super.init(frame: .zero)
    }
    
    override func configureAttributes() {
        let buttonImage = UIImage(named: "plus")?
            .resize(to: CGSize(width: 14, height: 14))
            .withRenderingMode(.alwaysTemplate)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = BridgeColor.primary1
        configuration.contentInsets = .zero
        
        configuration.image = buttonImage
        configuration.imagePlacement = .leading
        configuration.imagePadding = 1
        
        var titleContainer = AttributeContainer()
        titleContainer.font = titleFont
        titleContainer.foregroundColor = BridgeColor.primary1
        configuration.attributedTitle = AttributedString("추가", attributes: titleContainer)
        
        self.configuration = configuration
    }
    
    /// 컨텐츠가 추가되었을 경우, 버튼 타이틀을 변경
    private func updateButtonConfiguration() {
        if isAdded {
            var titleContainer = AttributeContainer()
            titleContainer.font = titleFont
            titleContainer.foregroundColor = BridgeColor.primary1
            configuration?.attributedTitle = AttributedString("수정", attributes: titleContainer)
            configuration?.image = nil
        } else {
            configureAttributes()
        }
    }
}
