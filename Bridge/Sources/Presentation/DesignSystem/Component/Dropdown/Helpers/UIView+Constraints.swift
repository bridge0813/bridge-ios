//
//  UIView+Constraints.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/03.
//

import UIKit

// MARK: - Constraints
extension UIView {
    
    /// 주어진 VFL(Visual Format Language) 포맷 문자열을 사용하여 제약 조건을 생성하는 메서드
    /// NSLayoutConstraint.constraints() 함수를 사용하여 VFL 문자열을 실제 제약조건으로 변환한다.
    /// format - 제약 조건을 정의하는 VFL 문자열
    /// options - 제약 조건의 추가적인 옵션(기본 값은 [])
    /// metrics - 제약 조건 내에서 사용될 수치 값(기본 값은 nil)
    /// views - VFL 문자열 내에서 참조될 뷰들의 Dictionary
    func addConstraints(
        format: String,
        options: NSLayoutConstraint.FormatOptions = [],
        metrics: [String: AnyObject]? = nil,
        views: [String: UIView]
    ) {
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: format,
            options: options,
            metrics: metrics,
            views: views
        ))
    }
    
    /// 주어진 format을 사용해서 가로(H)와 세로(V)에 대한 제약조건을 추가하는 메서드.
    func addUniversalConstraints(
        format: String,
        options: NSLayoutConstraint.FormatOptions = [],
        metrics: [String: AnyObject]? = nil,
        views: [String: UIView]
    ) {
        addConstraints(format: "H:\(format)", options: options, metrics: metrics, views: views)
        addConstraints(format: "V:\(format)", options: options, metrics: metrics, views: views)
    }
}

// MARK: - Window
extension UIView {
    
    /// 현재 뷰의 프레임을 윈도우 좌표계로 변환하여 반환한다. 즉, 이 뷰가 전체 화면에서 어디에 위치하는지에 대한 프레임 정보를 가져올 수 있디.
    var windowFrame: CGRect? {
        return superview?.convert(frame, to: nil)
    }
}

extension UIWindow {
    
    /// 현재 화면에서 사용자에게 보이는 주 윈도우를 반환한다.
    static func visibleWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes           // 현재 연결된 모든 UIScene을 가져옴
            .compactMap { $0 as? UIWindowScene }              // UIScene 중 UIWindowScene만 필터링 및 안전한 캐스팅
            .first?.windows.first(where: { $0.isKeyWindow })  // isKeyWindow 프로퍼티가 true인 주 윈도우를 반환
    }
}
