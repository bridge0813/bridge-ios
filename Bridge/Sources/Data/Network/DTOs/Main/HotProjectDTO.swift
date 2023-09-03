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
    let deadlineDate: Date
}

extension HotProjectDTO {
    func toModel() -> HotProject {
        HotProject(
            id: id,
            title: title,
            numberOfRecruits: numberOfRecruits,
            dDays: Date().calculateDDay(to: deadlineDate)
        )
    }
}
