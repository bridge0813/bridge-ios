//
//  TagButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/14.
//

import UIKit

final class FieldTagButton: UIButton {
    override var isSelected: Bool {
        didSet {
            updateButtonStyle()
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        updateButtonStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateButtonStyle() {
        if isSelected {
            applySelectedStyle()
        } else {
            applyDefaultStyle()
        }
    }
    
    private func applyDefaultStyle() {
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .lightGray
        self.configuration = configuration
        
        setTitleColor(.darkGray, for: .normal)
        setTitleColor(.darkGray, for: .highlighted)
        layer.borderWidth = 0
    }
    
    private func applySelectedStyle() {
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .white
        self.configuration = configuration
        
        setTitleColor(.orange, for: .selected)
        layer.borderColor = UIColor.orange.cgColor
        layer.borderWidth = 1
    }
}
