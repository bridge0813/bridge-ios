//
//  UIViewController+Keyboard.swift
//  Bridge
//
//  Created by 정호윤 on 10/19/23.
//

import UIKit

extension UIViewController {
    /// 화면의 빈 공간을 터치해 키보드를 가리고 싶은 경우, 필요한 뷰 컨트롤러에서 메서드 호출.
    /// 사용 시  tap gesture recognizer간 충돌 발생하지 않도록 주의해서 사용해야함.
    func enableKeyboardHiding(shouldCancelTouchesInView: Bool = true) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = shouldCancelTouchesInView
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
