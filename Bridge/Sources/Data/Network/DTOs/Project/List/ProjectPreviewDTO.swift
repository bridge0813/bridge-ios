//
//  ProjectDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation

struct ProjectPreviewDTO: Codable {
    let projectID: Int
    let title: String
    let deadline: String
    let totalRecruitNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case projectID = "projectId"
        case deadline = "dueDate"
        case totalRecruitNumber = "recruitTotalNum"
    }
}

extension ProjectPreviewDTO {
    func toEntity() -> ProjectPreview {
        ProjectPreview(
            projectID: projectID,
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
        ProjectPreviewDTO(projectID: 0, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 6),
        ProjectPreviewDTO(projectID: 1, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 5),
        ProjectPreviewDTO(projectID: 2, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 3),
        ProjectPreviewDTO(projectID: 3, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 6),
        ProjectPreviewDTO(projectID: 4, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 8),
        ProjectPreviewDTO(projectID: 5, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 8),
        ProjectPreviewDTO(projectID: 6, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 7)
    ]
}
