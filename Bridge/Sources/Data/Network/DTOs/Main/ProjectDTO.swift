//
//  ProjectDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation

struct ProjectDTO: Codable {
    let id: String
    let title: String
    let fields: [RecruitmentField]
    let requiredFieldTag: [String]
    let requiredStackTag: [String]
    let startDate: Date
    let endDate: Date
    let deadlineDate: Date  // 공고 모집마감 날짜
}
