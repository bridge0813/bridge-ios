//
//  FieldRequirement.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/15.
//

import Foundation

struct FieldRequirement: Codable {
    let field: String         // 분야
    let recruitNumber: Int    // 모집 인원 수
    let techStacks: [String]  // 기술 스택
    let expectaions: String   // 바라는 점
}
