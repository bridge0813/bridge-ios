//
//  HotProjectResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/27.
//

import Foundation

struct HotProjectResponseDTO: Decodable {
    let projectID: Int
    let title: String
    let deadline: String
    let rank: Int
    let totalRecruitNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case title, rank
        case projectID = "projectId"
        case deadline = "dueDate"
        case totalRecruitNumber = "recruitNum"
    }
}

extension HotProjectResponseDTO {
    func toEntity() -> ProjectPreview {
        ProjectPreview(
            projectID: projectID,
            title: title,
            description: "",
            dDays: Date().calculateDDay(to: deadline.toDate(with: "yyyy-MM-dd'T'HH:mm:ss")),
            deadline: deadline.toDate(with: "yyyy-MM-dd'T'HH:mm:ss").toString(format: "yyyy.MM.dd"),
            totalRecruitNumber: totalRecruitNumber,
            rank: rank,
            deadlineRank: 0
        )
    }
}
