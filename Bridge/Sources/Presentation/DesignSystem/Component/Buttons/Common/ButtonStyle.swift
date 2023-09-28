//
//  ButtonStyle.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/28.
//

import UIKit

enum ButtonStyle {
    case confirm
    case cancel
    case apply
    case detail
    
    var backgroundColor: UIColor {
        switch self {
        case .confirm, .apply, .detail:
            return BridgeColor.primary1
            
        case .cancel:
            return BridgeColor.gray4
        }
    }
    
    var font: UIFont {
        switch self {
        case .confirm, .cancel, .detail:
            return BridgeFont.button2.font
            
        case .apply:
            return BridgeFont.subtitle2.font
        }
    }
}
