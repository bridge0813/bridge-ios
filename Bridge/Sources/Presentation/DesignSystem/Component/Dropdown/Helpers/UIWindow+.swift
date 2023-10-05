//
//  UIWindow+.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/03.
//

import UIKit

// MARK: - Window
extension UIWindow {
    /// 현재 화면에서 사용자에게 보이는 주 윈도우를 반환한다.
    static func visibleWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes           // 현재 연결된 모든 UIScene을 가져옴
            .compactMap { $0 as? UIWindowScene }              // UIScene 중 UIWindowScene만 필터링 및 안전한 캐스팅
            .first?.windows.first(where: { $0.isKeyWindow })  // isKeyWindow 프로퍼티가 true인 주 윈도우를 반환
    }
}


extension UIView {
    /// 현재 뷰의 프레임을 윈도우 좌표계로 변환하여 반환한다. 즉, 이 뷰가 전체 화면에서 어디에 위치하는지에 대한 프레임 정보를 가져올 수 있디.
    var windowFrame: CGRect? {
        return superview?.convert(frame, to: nil)
    }
}

