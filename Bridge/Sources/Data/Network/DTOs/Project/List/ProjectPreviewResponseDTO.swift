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
    let isBookmarked: Bool
    
    enum CodingKeys: String, CodingKey {
        case title
        case projectID = "projectId"
        case deadline = "dueDate"
        case totalRecruitNumber = "recruitTotalNum"
        case isBookmarked = "scrap"
    }
}

extension ProjectPreviewResponseDTO {
    func toEntity() -> ProjectPreview {
        ProjectPreview(
            projectID: projectID,
            title: title,
            description: "",
            dDays: Date().calculateDDay(to: deadline.toDateType() ?? Date()),
            deadline: deadline.toDate(format: "yyyy.MM.dd") ?? "",
            totalRecruitNumber: totalRecruitNumber,
            rank: 0,
            deadlineRank: 0,
            isBookmarked: isBookmarked,
            status: ""
        )
    }
}

extension ProjectPreviewResponseDTO {
    static var projectTestArray: [ProjectPreviewResponseDTO] = [
        ProjectPreviewResponseDTO(projectID: 0, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2024-01-27T21:37:19", totalRecruitNumber: 6, isBookmarked: false),
        ProjectPreviewResponseDTO(projectID: 1, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2024-01-27T21:37:19", totalRecruitNumber: 5, isBookmarked: false),
        ProjectPreviewResponseDTO(projectID: 2, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2024-02-27T21:37:19", totalRecruitNumber: 3, isBookmarked: false),
        ProjectPreviewResponseDTO(projectID: 3, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2024-02-27T21:37:19", totalRecruitNumber: 6, isBookmarked: false),
        ProjectPreviewResponseDTO(projectID: 4, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2024-02-27T21:37:19", totalRecruitNumber: 8, isBookmarked: false),
        ProjectPreviewResponseDTO(projectID: 5, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2024-02-27T21:37:19", totalRecruitNumber: 8, isBookmarked: false),
        ProjectPreviewResponseDTO(projectID: 6, title: "실제 상업용 여행사 웹사이트 개발할 개발자 구합니다", deadline: "2024-02-27T21:37:19", totalRecruitNumber: 7, isBookmarked: false)
    ]
    
    static var projectByFieldTestArray: [ProjectPreviewResponseDTO] = [
        ProjectPreviewResponseDTO(projectID: 16, title: "iOS 개발자만 구합니데이", deadline: "2024-02-27T21:37:19", totalRecruitNumber: 6, isBookmarked: true),
        ProjectPreviewResponseDTO(projectID: 15, title: "백엔드 개발자만 구합니데이다라라아아리어로에장;나아니ㅏㅁ마아", deadline: "2024-02-27T21:37:19", totalRecruitNumber: 5, isBookmarked: true),
        ProjectPreviewResponseDTO(projectID: 17, title: "디자이너만 구합니다요", deadline: "2024-02-27T21:37:19", totalRecruitNumber: 3, isBookmarked: true),
        ProjectPreviewResponseDTO(projectID: 18, title: "기획자, 기획자, 아이오에스 개발자, 안드로이드 개발자, 프론트엔드 개발자 구합니다.", deadline: "2024-02-27T21:37:19", totalRecruitNumber: 3, isBookmarked: true),
        ProjectPreviewResponseDTO(projectID: 4, title: "네 번째", deadline: "2024-02-27T21:37:19", totalRecruitNumber: 3, isBookmarked: true),
        ProjectPreviewResponseDTO(projectID: 5, title: "다섯 번째", deadline: "2024-02-27T21:37:19", totalRecruitNumber: 3, isBookmarked: true)
    ]
}
