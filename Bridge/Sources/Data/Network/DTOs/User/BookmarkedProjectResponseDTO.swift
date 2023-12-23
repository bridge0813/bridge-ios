//
//  BookmarkedProjectResponseDTO.swift
//  Bridge
//
//  Created by 정호윤 on 12/23/23.
//

import Foundation

struct BookmarkedProjectResponseDTO: Decodable {
    let id: Int
    let title: String
    let dueDate: String
    let totalRecruitNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "projectId"
        case title
        case dueDate
        case totalRecruitNumber = "recruitTotalNum"
    }
}

extension BookmarkedProjectResponseDTO {
    func toEntity() -> BookmarkedProject {
        BookmarkedProject(
            id: id,
            title: title,
            dueDate: dueDate.toDate() ?? "",
            totalRecruitNumber: totalRecruitNumber
        )
    }
}

extension BookmarkedProjectResponseDTO {
    static var testData = [
        BookmarkedProjectResponseDTO(
            id: 1,
            title: "테이블링 IOS앱 구현할 팀원 구해요",
            dueDate: "2023-09-05T09:15:30+00:00",
            totalRecruitNumber: 1
        ),
        BookmarkedProjectResponseDTO(
            id: 2,
            title: "테이블링 IOS앱 구현할 팀원 구해요2",
            dueDate: "2023-09-05T09:15:30+00:00",
            totalRecruitNumber: 6
        ),
        BookmarkedProjectResponseDTO(
            id: 3,
            title: "테이블링 IOS앱 구현할 팀원 구해요3",
            dueDate: "2023-09-05T09:15:30+00:00",
            totalRecruitNumber: 10
        )
    ]
}
