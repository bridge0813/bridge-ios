//
//  UIView+RxKeyboard.swift
//  Bridge
//
//  Created by 정호윤 on 10/19/23.
//

import UIKit
import RxSwift

extension Reactive where Base: UIView {
    /// 바뀐 키보드의 레이아웃을 방출
    var keyboardLayoutChanged: Observable<CGFloat> {
        /// 키보드가 나타날 때, 그 높이를 방출
        let keyboardWillShow = NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 291
            }
        
        /// 키보드가 사라질 때, 바뀌어야 할 높이를 방출
        let keyboardWillHide = NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in 0 }
        
        return Observable.merge(keyboardWillShow, keyboardWillHide)
    }
    
    var yPosition: Binder<CGFloat> {
        Binder(base) { view, keyboardHeight in
            UIView.animate(withDuration: 0.3) {
                if keyboardHeight == 0 {
                    view.transform = CGAffineTransform.identity
                } else {
                    // rootFlexContainer의 superview에 접근하기 위해 superview 두 번 체이닝
                    let yPosition = keyboardHeight - (view.superview?.superview?.safeAreaInsets.bottom ?? 34)
                    view.transform = CGAffineTransform(translationX: 0, y: -yPosition)
                }
            }
        }
    }
}
