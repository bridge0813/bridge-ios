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
    let fieldRequirements: [FieldRequirement]
}

extension ProjectDTO {
    func toModel() -> Project {
        Project(
            id: id,
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

extension ProjectDTO {
    static var projectTestArray = [
        ProjectDTO(
            id: "1",
            title: "모임 플랫폼 디자이너 구합니다",
            numberOfRecruits: 1,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date(),
            fieldRequirements: []
        ),
        ProjectDTO(
            id: "2",
            title: "웹 사이트 디자이너 구해요!!",
            numberOfRecruits: 1,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date(),
            fieldRequirements: []
        ),
        ProjectDTO(
            id: "3",
            title: "개발자, 디자이너 구합니다",
            numberOfRecruits: 6,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date(),
            fieldRequirements: []
        ),
        ProjectDTO(
            id: "4",
            title: "iOS 개발자 구합니다",
            numberOfRecruits: 4,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date(),
            fieldRequirements: []
        ),
        ProjectDTO(
            id: "5",
            title: "모임 플랫폼 디자이너 구합니다",
            numberOfRecruits: 1,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date(),
            fieldRequirements: []
        )
    ]
    
    static var hotProjectTestArray = [
        ProjectDTO(
            id: "1Hot",
            title: "모임 플랫폼 디자이너 구합니다",
            numberOfRecruits: 1,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date(),
            fieldRequirements: []
        ),
        ProjectDTO(
            id: "2Hot",
            title: "웹 사이트 디자이너 구해요!!",
            numberOfRecruits: 1,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date(),
            fieldRequirements: []
        ),
        ProjectDTO(
            id: "3Hot",
            title: "개발자, 디자이너 구합니다",
            numberOfRecruits: 6,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date(),
            fieldRequirements: []
        ),
        ProjectDTO(
            id: "4Hot",
            title: "iOS 개발자 구합니다",
            numberOfRecruits: 4,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date(),
            fieldRequirements: []
        ),
        ProjectDTO(
            id: "5Hot",
            title: "모임 플랫폼 기획자 구합니다",
            numberOfRecruits: 1,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date(),
            fieldRequirements: []
        )
    ]
}
