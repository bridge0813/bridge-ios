//
//  UITextField+.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/15.
//

import UIKit

extension UITextField {
    func addLeftPadding(with width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
