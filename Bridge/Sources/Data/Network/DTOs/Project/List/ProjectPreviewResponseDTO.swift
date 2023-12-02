//
//  ProjectPreviewResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation

struct ProjectPreviewResponseDTO: Decodable {
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

extension ProjectPreviewResponseDTO {
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

extension ProjectPreviewResponseDTO {
    static var projectTestArray: [ProjectPreviewResponseDTO] = [
        ProjectPreviewResponseDTO(projectID: 0, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 6),
        ProjectPreviewResponseDTO(projectID: 1, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 5),
        ProjectPreviewResponseDTO(projectID: 2, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 3),
        ProjectPreviewResponseDTO(projectID: 3, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 6),
        ProjectPreviewResponseDTO(projectID: 4, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 8),
        ProjectPreviewResponseDTO(projectID: 5, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 8),
        ProjectPreviewResponseDTO(projectID: 6, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2023.08.20", totalRecruitNumber: 7)
    ]
}
