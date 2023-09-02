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
    let numberOfRecruits: Int
    let recruitmentField: [String]
    let techStackTags: [String]
    let startDate: Date
    let endDate: Date
    let deadlineDate: Date
}

extension ProjectDTO {
    func toModel() -> Project {
        Project(
            id: id,
            title: title,
            numberOfRecruits: numberOfRecruits,
            recruitmentField: recruitmentField,
            techStackTags: techStackTags,
            dDays: Date().calculateDDay(to: endDate),
            startDate: startDate.toString(),
            endDate: endDate.toString(),
            scrapCount: 0
        )
    }
}
