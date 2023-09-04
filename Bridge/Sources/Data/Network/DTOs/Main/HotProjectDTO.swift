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

extension HotProjectDTO {
    static var hotProjectTestArray = [
        HotProjectDTO(
            id: "1",
            title: "모임 플랫폼 디자이너 구합니다",
            numberOfRecruits: 1,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date()
        ),
        HotProjectDTO(
            id: "2",
            title: "웹 사이트 디자이너 구해요!!",
            numberOfRecruits: 1,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date()
        ),
        HotProjectDTO(
            id: "3",
            title: "개발자, 디자이너 구합니다",
            numberOfRecruits: 6,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date()
        ),
        HotProjectDTO(
            id: "4",
            title: "iOS 개발자 구합니다",
            numberOfRecruits: 4,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date()
        ),
        HotProjectDTO(
            id: "5",
            title: "여행 플랫폼 개발자 구해요!",
            numberOfRecruits: 1,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date()
        )
    ]
}
