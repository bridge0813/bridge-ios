//
//  HotProjectDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/03.
//

import Foundation

struct HotProjectDTO: Codable {
    let id: String
    let title: String
    let numberOfRecruits: Int
    let recruitmentField: [String]
    let techStackTags: [String]
    let startDate: Date
    let endDate: Date
    let deadlineDate: Date
}

extension HotProjectDTO {
    func toModel() -> Project {
        Project(
            id: id + "Hot",
            title: title,
            numberOfRecruits: numberOfRecruits,
            recruitmentField: recruitmentField,
            techStackTags: techStackTags,
            dDays: Date().calculateDDay(to: deadlineDate),
            startDate: startDate.toString(),
            endDate: endDate.toString()
        )
    }
}
