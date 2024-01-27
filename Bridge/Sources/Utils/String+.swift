//
//  String+.swift
//  Bridge
//
//  Created by 엄지호 on 1/9/24.
//

import Foundation

extension String {
    /// 서버 요청을 위한 대문자 형태로 수정
    func convertToUpperCaseFormat() -> String {
        switch self {
        case "iOS": return "IOS"
        case "안드로이드": return "ANDROID"
        case "프론트엔드": return "FRONTEND"
        case "백엔드": return "BACKEND"
        case "UI/UX": return "UIUX"
        case "BI/BX": return "BIBX"
        case "영상/모션": return "VIDEOMOTION"
        case "PM": return "PM"
        default: return "Error"
        }
    }
    
    /// 유저에게 보여주는 이름으로 전환
    func convertToDisplayFormat() -> String {
        switch self {
        case "IOS": return "iOS"
        case "ANDROID": return "안드로이드"
        case "FRONTEND": return "프론트엔드"
        case "BACKEND": return "백엔드"
        case "UIUX": return "UI/UX"
        case "BIBX": return "BI/BX"
        case "VIDEOMOTION": return "영상/모션"
        case "PM": return "PM"
        default: return "Error"
        }
    }
    
    /// 분야에 맞는 카테고리 이름을 반환
    func categoryForField() -> String {
        switch self {
        case "iOS", "안드로이드", "프론트엔드", "백엔드":
            return "개발자"
            
        case "UI/UX", "BI/BX", "영상/모션":
            return "디자이너"
            
        case "PM":
            return "기획자"
            
        default:
            return "Error"
        }
    }
}
