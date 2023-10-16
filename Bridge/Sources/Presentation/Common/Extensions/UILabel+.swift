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
    
    // 출처: https://sujinnaljin.medium.com/swift-label의-line-height-설정-및-가운데-정렬-962f7c6e7512
    func configureTextWithLineHeight(text: String?, lineHeight: CGFloat, alignment: NSTextAlignment = .left) {
        guard let text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .baselineOffset: (lineHeight - font.lineHeight) / 4
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        attributedText = attributedString
    }
}
