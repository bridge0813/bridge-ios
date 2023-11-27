//
//  DeadlineProjectResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/27.
//

import Foundation

struct DeadlineProjectResponseDTO: Decodable {
    let projectId: Int
    let title: String
    let deadline: String
    let deadlineRank: Int
    let totalRecruitNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case projectId, title
        case deadline = "dueDate"
        case deadlineRank = "imminentRank"
        case totalRecruitNumber = "recruitNum"
    }
}

extension DeadlineProjectResponseDTO {
    func toEntity() -> ProjectPreview {
        ProjectPreview(
            projectId: projectId,
            title: title,
            description: "",
            dDays: Date().calculateDDay(to: deadline.toDate(with: "yyyy-MM-dd'T'HH:mm:ss")),
            deadline: deadline.toDate(with: "yyyy-MM-dd'T'HH:mm:ss").toString(format: "yyyy.MM.dd"),
            totalRecruitNumber: totalRecruitNumber,
            rank: 0,
            deadlineRank: deadlineRank
        )
    }
}
