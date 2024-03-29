//
//  AppliedProjectResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 12/8/23.
//

import Foundation

struct AppliedProjectResponseDTO: Decodable {
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

extension AppliedProjectResponseDTO {
    func toEntity() -> ProjectPreview {
        ProjectPreview(
            projectID: projectID,
            title: title,
            description: description,
            dDays: 0,
            deadline: deadline.toDateType()?.toString(format: "yyyy.M.dd") ?? "",
            totalRecruitNumber: 0,
            rank: 0,
            deadlineRank: 0,
            isBookmarked: false, 
            status: formatProjectStatusText(status: status)
        )
    }
    
    private func formatProjectStatusText(status: String) -> String {
        switch status {
        case "대기중": return "결과 대기중"
        default: return status
        }
    }
}

extension AppliedProjectResponseDTO {
    static var projectTestArray: [AppliedProjectResponseDTO] = [
        AppliedProjectResponseDTO(projectID: 0, title: "지원 탭에서 보내는 첫 번째 모집글입니다. 아라라라라라라라라라라리리리리리요요요라라라라", description: "기획부터 앱 출시까지 함께하실 팀원을 모집중입니다.....ㅇㅋㅋㅋㅋ가나다라마바사가나다라마바사", deadline: "2023-12-25T21:37:19", status: "수락"),
        AppliedProjectResponseDTO(projectID: 1, title: "지원 탭에서 보내는 두 번째 모집글입니다.", description: "기획부터 앱 출시까지 함께하실 팀원을 모집중입니다", deadline: "2024-01-01T21:37:19", status: "거절"),
        AppliedProjectResponseDTO(projectID: 2, title: "지원 탭에서 보내는 세 번째 모집글입니다.", description: "기획부", deadline: "2024-02-27T21:37:19", status: "대기중"),
        AppliedProjectResponseDTO(projectID: 3, title: "지원 탭에서 보내는 네 번째 모집글입니다.", description: "기획", deadline: "2024-02-27T21:37:19", status: "대기중"),
        AppliedProjectResponseDTO(projectID: 4, title: "다섯 번째 모집글입니다.", description: "기획부터 앱 출시까지 함께하실 팀원을 모집중입니다", deadline: "2024-05-01T21:37:19", status: "수락"),
        AppliedProjectResponseDTO(projectID: 5, title: "여섯 번째.", description: "기획부터 앱 출시까지", deadline: "2024-02-27T21:37:19", status: "거절")
    ]
}
