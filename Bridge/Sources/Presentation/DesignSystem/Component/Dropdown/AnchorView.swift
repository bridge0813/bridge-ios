//
//  AnchorView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/05.
//

import UIKit

/// 드롭다운을 트리거하는 뷰로 이를 기준으로 드롭다운의 레이아웃을 설정한다.
protocol AnchorView: AnyObject {
    var plainView: UIView { get }
}

extension UIView: AnchorView {
    var plainView: UIView {
        return self
    }
}

extension UIBarButtonItem: AnchorView {
    var plainView: UIView {
        return value(forKey: "view") as? UIView ?? UIView()
    }
}
