//
//  HotProjectResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/27.
//

import Foundation

struct HotProjectResponseDTO: Decodable {
    let projectId: Int
    let title: String
    let deadline: String
    let rank: Int
    let totalRecruitNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case projectId, title, rank
        case deadline = "dueDate"
        case totalRecruitNumber = "recruitTotalNum"
    }
}

extension HotProjectResponseDTO {
    func toEntity() -> ProjectPreview {
        ProjectPreview(
            projectId: projectId,
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
