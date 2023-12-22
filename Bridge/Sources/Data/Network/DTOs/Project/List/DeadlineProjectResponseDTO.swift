//
//  DeadlineProjectResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/27.
//

import Foundation

struct DeadlineProjectResponseDTO: Decodable {
    let projectID: Int
    let title: String
    let deadline: String
    let deadlineRank: Int
    let totalRecruitNumber: Int
    let isBookmarked: Bool
    
    enum CodingKeys: String, CodingKey {
        case title
        case projectID = "projectId"
        case deadline = "dueDate"
        case deadlineRank = "imminentRank"
        case totalRecruitNumber = "recruitNum"
        case isBookmarked = "scrap"
    }
}

extension DeadlineProjectResponseDTO {
    func toEntity() -> ProjectPreview {
        ProjectPreview(
            projectID: projectID,
            title: title,
            description: "",
            dDays: Date().calculateDDay(to: deadline.toDateType() ?? Date()),
            deadline: deadline.toDate(format: "yyyy.MM.dd") ?? "",
            totalRecruitNumber: totalRecruitNumber,
            rank: 0,
            deadlineRank: deadlineRank,
            isBookmarked: isBookmarked, 
            status: ""
        )
    }
}

extension DeadlineProjectResponseDTO {
    static var projectTestArray: [DeadlineProjectResponseDTO] = [
        DeadlineProjectResponseDTO(projectID: 0, title: "여긴 마감임박 이다. 첫 번째 마감임박 모집글입니다. 이건 첫 번째 마감임박 모집글입니다.", deadline: "2024-02-27T21:37:19", deadlineRank: 0, totalRecruitNumber: 1, isBookmarked: true),
        DeadlineProjectResponseDTO(projectID: 1, title: "두 번째 마감임박 글입니다.", deadline: "2024-02-27T21:37:19", deadlineRank: 0, totalRecruitNumber: 2, isBookmarked: true),
        DeadlineProjectResponseDTO(projectID: 2, title: "세 번째 마감임박 글입니다.", deadline: "2024-02-27T21:37:19", deadlineRank: 0, totalRecruitNumber: 3, isBookmarked: true),
        DeadlineProjectResponseDTO(projectID: 3, title: "네 번째 마감임박 글입니다.", deadline: "2024-02-27T21:37:19", deadlineRank: 0, totalRecruitNumber: 4, isBookmarked: false),
        DeadlineProjectResponseDTO(projectID: 4, title: "다섯 번째 마감임박 글입니다.", deadline: "2024-02-27T21:37:19", deadlineRank: 0, totalRecruitNumber: 5, isBookmarked: false)
    ]
}
