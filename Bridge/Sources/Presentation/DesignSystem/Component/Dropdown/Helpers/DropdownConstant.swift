//
//  DropdownConstant.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/01.
//

import UIKit

// DropDown 라이브러리에서 사용하는 여러 상수들을 정의
internal struct DPDConstant {

    /// 재사용가능한 셀 식별자를 정의 이는 테이블 뷰나 컬렉션 뷰에서 셀을 재사용할 때, 사용됨.
    internal struct KeyPath {

        static let Frame = "frame"

    }

    /// 재사용가능한 셀 식별자를 정의 이는 테이블 뷰나 컬렉션 뷰에서 셀을 재사용할 때, 사용됨.
    internal struct ReusableIdentifier {

        static let DropDownCell = "DropDownCell"

    }
    
    /// UI관련 상수들을 정의
    internal struct UI {

        static let TextColor = UIColor.black
        static let SelectedTextColor = UIColor.black
        static let TextFont = UIFont.systemFont(ofSize: 15)
        static let BackgroundColor = UIColor(white: 0.94, alpha: 1)
        static let SelectionBackgroundColor = BridgeColor.primary3
        static let SeparatorColor = UIColor.clear
        static let CornerRadius: CGFloat = 2
        static let RowHeight: CGFloat = 44
        static let HeightPadding: CGFloat = 20

        /// 그림자와 관련된 상수들을 정의
        struct Shadow {

            static let Color = UIColor.black
            static let Offset = CGSize.zero
            static let Opacity: Float = 0.7
            static let Radius: CGFloat = 0.4

        }

    }

    /// 애니메이션과 관련된 상수들을 정의
    internal struct Animation {

        static let Duration = 0.2
        static let EntranceOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseOut]
        static let ExitOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseIn]
        static let DownScaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)

    }
}
