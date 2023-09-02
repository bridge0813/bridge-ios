//
//  UILabel+.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/03.
//

import UIKit

extension UILabel {
    func configureLabel(
        textColor: UIColor,
        font: UIFont,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 1
    ) {
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}
