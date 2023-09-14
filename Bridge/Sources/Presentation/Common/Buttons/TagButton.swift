//
//  TagButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/14.
//

import UIKit

final class TagButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)
        
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .lightGray

        self.configuration = configuration
        self.setTitle(title, for: .normal)
        self.setTitleColor(.darkGray, for: .normal)
        self.setTitleColor(.darkGray, for: .highlighted)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
