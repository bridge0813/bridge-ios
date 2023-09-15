//
//  FieldRequirement.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/15.
//

import Foundation

struct FieldRequirement: Codable {
    var field: String         // 분야
    var recruitNumber: Int    // 모집 인원 수
    var techStacks: [String]  // 기술 스택
    var expectaions: String   // 바라는 점
}
