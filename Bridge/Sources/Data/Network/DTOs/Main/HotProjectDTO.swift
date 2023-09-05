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

extension HotProjectDTO {
    static var hotProjectTestArray = [
        HotProjectDTO(
            id: "1",
            title: "기획자 구해요~",
            numberOfRecruits: 3,
            deadlineDate: Date()
        ),
        HotProjectDTO(
            id: "2",
            title: "웹 사이트 디자이너 구해요!!",
            numberOfRecruits: 1,
            deadlineDate: Date()
        ),
        HotProjectDTO(
            id: "3",
            title: "개발자, 디자이너 구합니다",
            numberOfRecruits: 6,
            deadlineDate: Date()
        ),
        HotProjectDTO(
            id: "4",
            title: "iOS 개발자 구합니다",
            numberOfRecruits: 4,
            deadlineDate: Date()
        ),
        HotProjectDTO(
            id: "5",
            title: "여행 플랫폼 개발자 구해요!",
            numberOfRecruits: 1,
            deadlineDate: Date()
        )
    ]
}
