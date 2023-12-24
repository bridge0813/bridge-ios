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
    let dDay: Int
    let startDate: String
    let endDate: String
    let totalRecruitNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "projectId"
        case title
        case dDay
        case startDate
        case endDate
        case totalRecruitNumber = "recruitTotalNum"
    }
}

extension BookmarkedProjectResponseDTO {
    func toEntity() -> BookmarkedProject {
        BookmarkedProject(
            id: id,
            title: title,
            dDay: dDay,
            startDate: startDate,
            endDate: endDate,
            totalRecruitNumber: totalRecruitNumber
        )
    }
}

extension BookmarkedProjectResponseDTO {
    static var testData = [
        BookmarkedProjectResponseDTO(
            id: 1,
            title: "테이블링 IOS앱 구현할 팀원 구해요",
            dDay: 10,
            startDate: "2023-09-05T09:15:30+00:00",
            endDate: "2023-09-05T09:15:30+00:00",
            totalRecruitNumber: 1
        ),
        BookmarkedProjectResponseDTO(
            id: 2,
            title: "테이블링 IOS앱 구현할 팀원 구해요2",
            dDay: 1,
            startDate: "2023-09-05T09:15:30+00:00",
            endDate: "2023-09-05T09:15:30+00:00",
            totalRecruitNumber: 1
        ),
        BookmarkedProjectResponseDTO(
            id: 3,
            title: "테이블링 IOS앱 구현할 팀원 구해요3",
            dDay: 7,
            startDate: "2023-09-05T09:15:30+00:00",
            endDate: "2023-09-05T09:15:30+00:00",
            totalRecruitNumber: 10
        )
    ]
}
