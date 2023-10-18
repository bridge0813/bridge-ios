//
//  BridgeColor.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/25.
//

import UIKit

enum BridgeColor {
    // primary
    /// 주황색
    static let primary1 = UIColor(red: 255 / 255, green: 145 / 255, blue: 71 / 255, alpha: 1)
    static let primary2 = UIColor(red: 255 / 255, green: 243 / 255, blue: 235 / 255, alpha: 1)
    static let primary3 = UIColor(red: 255 / 255, green: 246 / 255, blue: 240 / 255, alpha: 1)
    
    // secondary
    /// 파란색
    static let secondary1 = UIColor(red: 92 / 255, green: 137 / 255, blue: 223 / 255, alpha: 1)
    static let secondary2 = UIColor(red: 117 / 255, green: 174 / 255, blue: 255 / 255, alpha: 1)
    static let secondary3 = UIColor(red: 210 / 255, green: 229 / 255, blue: 255 / 255, alpha: 1)
    static let secondary4 = UIColor(red: 235 / 255, green: 238 / 255, blue: 255 / 255, alpha: 1)
    static let secondary5 = UIColor(red: 239 / 255, green: 242 / 255, blue: 248 / 255, alpha: 1)
    static let secondary6 = UIColor(red: 248 / 255, green: 249 / 255, blue: 255 / 255, alpha: 1)

    
    // gray scale
    static let gray1 = UIColor(red: 38 / 255, green: 42 / 255, blue: 52 / 255, alpha: 1)
    static let gray2 = UIColor(red: 89 / 255, green: 89 / 255, blue: 89 / 255, alpha: 1)
    static let gray3 = UIColor(red: 153 / 255, green: 157 / 255, blue: 174 / 255, alpha: 1)
    static let gray4 = UIColor(red: 176 / 255, green: 183 / 255, blue: 196 / 255, alpha: 1)
    static let gray5 = UIColor(red: 210 / 255, green: 214 / 255, blue: 222 / 255, alpha: 1)
    static let gray6 = UIColor(red: 233 / 255, green: 233 / 255, blue: 233 / 255, alpha: 1)
    static let gray7 = UIColor(red: 236 / 255, green: 236 / 255, blue: 236 / 255, alpha: 1)
    static let gray8 = UIColor(red: 241 / 255, green: 241 / 255, blue: 241 / 255, alpha: 1)
    static let gray9 = UIColor(red: 246 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1)
    static let gray10 = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
    
    // system (tbd)
    static let systemRed = UIColor.systemRed
    static let systemBlue = UIColor.systemBlue
    static let systemYellow = UIColor.systemYellow
    static let systemGreen = UIColor.systemGreen
    
    /// 알림창 나올 때의 배경색
    static let backgroundBlur = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
}
