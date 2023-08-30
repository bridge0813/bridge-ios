//
//  RecruitmentField.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation

// 모집 분야와 인원
enum RecruitmentField: Codable {
    case developer(DeveloperSubField)
    case designer(DesignerSubField)
    case planner(PlannerSubField)
}

// 개발자에서 세부 분야 및 모집인원
enum DeveloperSubField: Codable {
    case iOS(Int)
    case android(Int)
    case frontend(Int)
    case backend(Int)
}

// 디자이너에서 세부 분야 및 모집인원
enum DesignerSubField: Codable {
    case uiux(Int)
    case bibx(Int)
    case videoMotion(Int)
}

// 기획자에서 세부 분야 및 및 모집인원
enum PlannerSubField: Codable {
    case pm(Int)
}
