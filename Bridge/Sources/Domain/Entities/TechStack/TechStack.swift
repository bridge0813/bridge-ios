//
//  TechStack.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/06.
//

import Foundation

/// 선택한 분야에 맞는 기술스택
enum TechStack: String {
    case ios = "iOS"
    case android = "안드로이드"
    case frontend = "프론트엔드"
    case backend = "백엔드"
    case uiux = "UI/UX"
    case bibx = "BI/BX"
    case videomotion = "영상/모션"
    case pm = "PM"
    
    var techStacks: [String] {
        switch self {
        case .ios: return ["Swift", "Objective-C", "UIKit", "SwiftUI", "RxSwift", "Combine", "XCTest", "Tuist", "React Native", "Flutter"]
            
        case .android: return ["Kotlin", "Java", "Compose", "RxJava", "Coroutine", "Flutter", "React Native"]
            
        case .frontend: return ["Javascript", "TypeScript", "HTML", "CSS", "React", "React Native", "Vue", "Angular", "Svelte", "Jquery", "Backbone", "Pinia"]
            
        case .backend: return ["Java", "Javascript", "Python", "TypeScript", "C", "C++", "Kotlin", "Spring", "Springboot", "Nodejs", "Django", "Hibernate", "WebRTC", "MongoDB", "MySQL", "PostgreSQL", "Redis", "Maria DB", "H2"]
            
        case .uiux: return ["photoshop", "illustrator", "indesign", "adobe XD", "Figma", "Sketch", "Adobe flash"]
            
        case .bibx: return ["photoshop", "illustrator", "indesign", "adobe XD", "Figma", "Sketch", "Adobe flash"]
            
        case .videomotion: return ["photoshop", "illustrator", "indesign", "adobe XD", "Figma", "Sketch", "Adobe flash"]
            
        case .pm: return ["Notion", "Jira", "Slack"]
        }
    }
}
