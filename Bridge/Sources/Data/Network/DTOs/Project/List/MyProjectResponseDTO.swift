//
//  MyProjectResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 12/9/23.
//

import Foundation

struct MyProjectResponseDTO: Decodable {
    let projectID: Int
    let title: String
    let description: String
    let deadline: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case projectID = "projectId"
        case description = "overview"
        case deadline = "dueDate"
        case status = "stage"
    }
}

extension MyProjectResponseDTO {
    func toEntity() -> ProjectPreview {
        ProjectPreview(
            projectID: projectID,
            title: title,
            description: description,
            dDays: 0,
            deadline: deadline.toDate(with: "yyyy-MM-dd'T'HH:mm:ss").toString(format: "yyyy.MM.dd"),
            totalRecruitNumber: 0,
            rank: 0,
            deadlineRank: 0,
            isBookmarked: false,
            status: formatProjectStatusText(status: status)
        )
    }
    
    private func formatProjectStatusText(status: String) -> String {
        switch status {
        case "현재 모집중": return "현재 진행중"
        case "마감": return "모집완료"
        default: return status
        }
    }
}

extension MyProjectResponseDTO {
    static var projectTestArray: [MyProjectResponseDTO] = [
        MyProjectResponseDTO(projectID: 0, title: "모집 탭에서 보내는 첫 번째 모집글입니다. 아라라라라라라라라라라리리리리리요요요라라라라", description: "기획부터 앱 출시까지 함께하실 팀원을 모집중입니다.....ㅇㅋㅋㅋㅋ가나다라마바사가나다라마바사", deadline: "2023.08.20", status: "현재 모집중"),
        MyProjectResponseDTO(projectID: 1, title: "모집 탭에서 보내는 두 번째 모집글입니다.", description: "기획부터 앱 출시까지 함께하실 팀원을 모집중입니다", deadline: "2023.08.20", status: "마감"),
        MyProjectResponseDTO(projectID: 2, title: "모집 탭에서 보내는 세 번째 모집글입니다.", description: "기획부", deadline: "2023.08.20", status: "마감"),
        MyProjectResponseDTO(projectID: 3, title: "모집 탭에서 보내는 네 번째 모집글입니다.", description: "기획", deadline: "2023.08.20", status: "마감"),
        MyProjectResponseDTO(projectID: 4, title: "모집 탭 모집글입니다.", description: "기획부터 앱 출시까지 함께하실 팀원을 모집중입니다", deadline: "2023.08.20", status: "현재 모집중"),
        MyProjectResponseDTO(projectID: 5, title: "모집", description: "기획부터 앱 출시까지", deadline: "2023.08.20", status: "현재 모집중"),
        MyProjectResponseDTO(projectID: 6, title: "마지막 모집글", description: "마지막", deadline: "2023.08.20", status: "마감")
    ]
}
