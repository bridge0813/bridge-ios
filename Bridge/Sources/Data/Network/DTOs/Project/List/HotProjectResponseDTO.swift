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
    let isBookmarked: Bool
    
    enum CodingKeys: String, CodingKey {
        case title, rank
        case projectID = "projectId"
        case deadline = "dueDate"
        case totalRecruitNumber = "recruitNum"
        case isBookmarked = "scrap"
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
            deadlineRank: 0,
            isBookmarked: isBookmarked
        )
    }
}

extension HotProjectResponseDTO {
    static var projectTestArray: [HotProjectResponseDTO] = [
        HotProjectResponseDTO(projectID: 0, title: "인기 탑 1에 들어와있는 모집글이며, 이거는 첫 번째이며 이런 사람을 구합니다.", deadline: "2023.08.20", rank: 1, totalRecruitNumber: 10, isBookmarked: false),
        HotProjectResponseDTO(projectID: 1, title: "인기 탑 2에 들어와있는 모집글", deadline: "2023.08.20", rank: 2, totalRecruitNumber: 15, isBookmarked: false),
        HotProjectResponseDTO(projectID: 2, title: "인기 탑 3에 들어와있는 모집글", deadline: "2023.08.20", rank: 2, totalRecruitNumber: 15, isBookmarked: false),
        HotProjectResponseDTO(projectID: 3, title: "인기 탑 4에 들어와있는 모집글", deadline: "2023.08.20", rank: 2, totalRecruitNumber: 15, isBookmarked: false),
        HotProjectResponseDTO(projectID: 4, title: "인기 탑 5에 들어와있는 모집글", deadline: "2023.08.20", rank: 2, totalRecruitNumber: 15, isBookmarked: false)
    ]
}
