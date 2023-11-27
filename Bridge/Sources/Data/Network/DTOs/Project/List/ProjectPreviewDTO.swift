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
    
    enum CodingKeys: String, CodingKey {
        case projectId, title
        case deadline = "dueDate"
        case totalRecruitNumber = "recruitTotalNum"
    }
}

extension ProjectPreviewDTO {
    func toEntity() -> ProjectPreview {
        ProjectPreview(
            projectId: projectId,
            title: title,
            description: "",
            dDays: Date().calculateDDay(to: deadline.toDate(with: "yyyy-MM-dd'T'HH:mm:ss")),
            deadline: deadline.toDate(with: "yyyy-MM-dd'T'HH:mm:ss").toString(format: "yyyy.MM.dd"),
            totalRecruitNumber: totalRecruitNumber,
            rank: 0,
            deadlineRank: 0
        )
    }
}

extension ProjectPreviewDTO {
    static var projectTestArray: [ProjectPreviewDTO] = [
        ProjectPreviewDTO(projectId: 0, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 6),
        ProjectPreviewDTO(projectId: 1, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 5),
        ProjectPreviewDTO(projectId: 2, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 3),
        ProjectPreviewDTO(projectId: 3, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 6),
        ProjectPreviewDTO(projectId: 4, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 8),
        ProjectPreviewDTO(projectId: 5, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 8),
        ProjectPreviewDTO(projectId: 6, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 7)
    ]
}
