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
    
    static var projectByFieldTestArray: [ProjectPreviewResponseDTO] = [
        ProjectPreviewResponseDTO(projectID: 0, title: "iOS 개발자만 구합니데이", deadline: "2023.08.20", totalRecruitNumber: 6),
        ProjectPreviewResponseDTO(projectID: 1, title: "백엔드 개발자만 구합니데이다라라아아리어로에장;나아니ㅏㅁ마아", deadline: "2023.08.20", totalRecruitNumber: 5),
        ProjectPreviewResponseDTO(projectID: 2, title: "디자이너만 구합니다요", deadline: "2023.08.20", totalRecruitNumber: 3),
        ProjectPreviewResponseDTO(projectID: 3, title: "기획자, 기획자, 아이오에스 개발자, 안드로이드 개발자, 프론트엔드 개발자 구합니다.", deadline: "2023.08.20", totalRecruitNumber: 3)
    ]
}
