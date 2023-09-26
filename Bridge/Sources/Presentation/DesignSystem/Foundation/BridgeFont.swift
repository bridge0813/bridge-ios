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
    
    public var font: UIFont {
        switch self {
        case .headline1, .headline1Long:
            return UIFont(name: "Pretendard-Bold", size: 20) ?? .systemFont(ofSize: 20, weight: .bold)
            
        case .subtitle1:                    
            return UIFont(name: "Pretendard-SemiBold", size: 18) ?? .systemFont(ofSize: 18, weight: .semibold)
            
        case .subtitle2:                    
            return UIFont(name: "Pretendard-SemiBold", size: 16) ?? .systemFont(ofSize: 16, weight: .semibold)
            
        case .subtitle3, .subtitle3Long:    
            return UIFont(name: "Pretendard-Medium", size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
            
        case .body1:
            return UIFont(name: "Pretendard-SemiBold", size: 14) ?? .systemFont(ofSize: 14, weight: .semibold)
            
        case .body2, .body2Long:
            return UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14, weight: .medium)
            
        case .body3:
            return UIFont(name: "Pretendard-Bold", size: 12) ?? .systemFont(ofSize: 12, weight: .bold)
            
        case .body4:
            return UIFont(name: "Pretendard-SemiBold", size: 24) ?? .systemFont(ofSize: 24, weight: .semibold)
            
        case .caption1:
            return UIFont(name: "Pretendard-Medium", size: 12) ?? .systemFont(ofSize: 12, weight: .medium)
            
        case .button1:
            return UIFont(name: "Pretendard-SemiBold", size: 16) ?? .systemFont(ofSize: 16, weight: .semibold)
            
        case .button2:
            return UIFont(name: "Pretendard-SemiBold", size: 14) ?? .systemFont(ofSize: 14, weight: .semibold)
            
        case .tag1:
            return UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14, weight: .medium)
        }
    }
    
    public var textColor: UIColor {
        switch self {
        case .headline1, .headline1Long:                            
            return UIColor(red: 36 / 255, green: 36 / 255, blue: 36 / 255, alpha: 1)
            
        case .subtitle1, .subtitle2, .subtitle3, .subtitle3Long:    
            return UIColor(red: 19 / 255, green: 25 / 255, blue: 39 / 255, alpha: 1)
            
        case .body1, .body2, .body2Long, .body3, .body4, .caption1: 
            return UIColor(red: 36 / 255, green: 36 / 255, blue: 36 / 255, alpha: 1)
            
        case .button1, .button2, .tag1:
            return UIColor(red: 19 / 255, green: 25 / 255, blue: 39 / 255, alpha: 1)
        }
    }
    
    public var lineHeight: CGFloat {
        switch self {
        case .headline1:        return 24
        case .headline1Long:    return 30
        case .subtitle1:        return 22
        case .subtitle2:        return 20
        case .subtitle3:        return 20
        case .subtitle3Long:    return 24
        case .body1:            return 18
        case .body2:            return 18
        case .body2Long:        return 20
        case .body3:            return 14
        case .body4:            return 14
        case .caption1:         return 14
        case .button1:          return 20
        case .button2:          return 18
        case .tag1:             return 18
        }
    }
}
