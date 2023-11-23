//
//  ProjectDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation

struct ProjectPreviewDTO: Codable {
    let projectId: Int
    let title: String
    let deadline: String
    let totalRecruitNumber: Int
}

extension ProjectPreviewDTO {
    func toEntity() -> ProjectPreview {
        ProjectPreview(
            projectId: projectId,
            title: title,
            description: "",
            dDays: Date().calculateDDay(to: deadline.toDate(with: "yyyy-MM-dd'T'HH:mm:ss")),
            deadline: deadline,
            totalRecruitNumber: totalRecruitNumber,
            rank: 0,
            deadlineRank: 0
        )
    }
}

extension ProjectPreviewDTO {
    static var projectTestArray: [ProjectPreviewDTO] = [
        ProjectPreviewDTO(projectId: 0, title: "", deadline: "", totalRecruitNumber: 0),
        ProjectPreviewDTO(projectId: 1, title: "", deadline: "", totalRecruitNumber: 0),
        ProjectPreviewDTO(projectId: 2, title: "", deadline: "", totalRecruitNumber: 0),
        ProjectPreviewDTO(projectId: 3, title: "", deadline: "", totalRecruitNumber: 0),
        ProjectPreviewDTO(projectId: 4, title: "", deadline: "", totalRecruitNumber: 0),
        ProjectPreviewDTO(projectId: 5, title: "", deadline: "", totalRecruitNumber: 0),
        ProjectPreviewDTO(projectId: 6, title: "", deadline: "", totalRecruitNumber: 0)
    ]
}
