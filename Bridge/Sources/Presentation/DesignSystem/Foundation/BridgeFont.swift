//
//  BridgeFont.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/25.
//

import UIKit

public enum BridgeFont {
    // title
    case headline1, headline1Long
    case subtitle1, subtitle2, subtitle3, subtitle3Long
    
    // body
    case body1, body2, body2Long, body3, body4
    case caption1
    
    // button & tag
    case button1, button2
    case tag1
    
    public var font: UIFont? {
        switch self {
        case .headline1, .headline1Long:    UIFont(name: "Pretendard-Bold", size: 20)
        case .subtitle1:                    UIFont(name: "Pretendard-SemiBold", size: 18)
        case .subtitle2:                    UIFont(name: "Pretendard-SemiBold", size: 16)
        case .subtitle3, .subtitle3Long:    UIFont(name: "Pretendard-Medium", size: 16)
        case .body1:                        UIFont(name: "Pretendard-SemiBold", size: 14)
        case .body2, .body2Long:            UIFont(name: "Pretendard-Medium", size: 14)
        case .body3:                        UIFont(name: "Pretendard-Bold", size: 12)
        case .body4:                        UIFont(name: "Pretendard-SemiBold", size: 24)
        case .caption1:                     UIFont(name: "Pretendard-Medium", size: 12)
        case .button1:                      UIFont(name: "Pretendard-SemiBold", size: 16)
        case .button2:                      UIFont(name: "Pretendard-SemiBold", size: 14)
        case .tag1:                         UIFont(name: "Pretendard-Medium", size: 14)
        }
    }
    
    public var textColor: UIColor {
        switch self {
        case .headline1, .headline1Long:                            
            UIColor(red: 36 / 255, green: 36 / 255, blue: 36 / 255, alpha: 1)
            
        case .subtitle1, .subtitle2, .subtitle3, .subtitle3Long:    
            UIColor(red: 19 / 255, green: 25 / 255, blue: 39 / 255, alpha: 1)
            
        case .body1, .body2, .body2Long, .body3, .body4, .caption1: 
            UIColor(red: 36 / 255, green: 36 / 255, blue: 36 / 255, alpha: 1)
            
        case .button1, .button2, .tag1:
            UIColor(red: 19 / 255, green: 25 / 255, blue: 39 / 255, alpha: 1)
        }
    }
    
    public var lineHeight: CGFloat {
        switch self {
        case .headline1:        24
        case .headline1Long:    30
        case .subtitle1:        22
        case .subtitle2:        20
        case .subtitle3:        20
        case .subtitle3Long:    24
        case .body1:            18
        case .body2:            18
        case .body2Long:        20
        case .body3:            14
        case .body4:            14
        case .caption1:         14
        case .button1:          20
        case .button2:          18
        case .tag1:             18
        }
    }
}
