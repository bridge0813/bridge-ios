//
//  ProjectDetailDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/15.
//

import Foundation

struct ProjectDetailDTO: Codable {
    let title: String
    let description: String
    let deadline: String
    let startDate: String?
    let endDate: String?
    let memberRequirements: [MemberRequirementDTO]
    let applicantRestrictions: [String]
    let progressMethod: String
    let progressStep: String
    let userName: String
    let isScrapped: Bool
    let isMyProject: Bool
    
    enum CodingKeys: String, CodingKey {
        case title, startDate, endDate, userName
        case description = "overview"
        case deadline = "dueDate"
        case memberRequirements = "recruit"
        case applicantRestrictions = "tagLimit"
        case progressMethod = "meetingWay"
        case progressStep = "stage"
        case isScrapped = "scrap"
        case isMyProject = "myProject"
    }
}

extension ProjectDetailDTO {
    // TODO: - Date형식으로 변경받을 수 있는지 여쭤보기
    func toEntity() -> ProjectDetail {
        ProjectDetail(
            title: title,
            description: description,
            dDays: Date().calculateDDay(to: deadline.toDate(with: "yyyy.MM.dd")),
            deadline: deadline.toDate(with: "yyyy.MM.dd"),
            startDate: startDate?.toDate(with: "yyyy.MM.dd"),
            endDate: endDate?.toDate(with: "yyyy.MM.dd"),
            memberRequirements: memberRequirements.map { $0.toEntity() },
            applicantRestrictions: applicantRestrictions,
            progressMethod: progressMethod,
            progressStep: progressStep,
            userName: userName,
            isScrapped: isScrapped,
            isMyProject: isMyProject
        )
    }
}

extension String {
    func toDate(with format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: self) ?? Date()
    }
}

extension ProjectDetailDTO {
    static var projectDetailTest = ProjectDTO(
        id: "1",
        title: "사이드 프젝으로 IOS앱을 같이 구현할 팀원을 구하고 있어요~",
        overview: "안녕하세요 기획부터 앱 출시까지 함께하실 팀원을 모집합니다! 현재 인원은 총 3명입니다. 저희는 개발자, 디자이너, 기횟들이 프로젝트나 스터디 모집을 쉽고 효과적으로 할 수 있게 돕는 IOS앱입니다. 현재는 다른 플랫폼과 차별화된 기능에 대한 기획정도만 마쳐진 상황이며, 추가적으로 더 진행될 예정입니다!",
        dueDate: Date(),
        startDate: Date(),
        endDate: Date(),
        recruit: [
            MemberRequirement(field: "ios", recruitNumber: 2, requiredSkills: ["Swift", "UIKit", "SwiftUI", "RxSwift", "RxCocoa"], requirementText: "스위프트 사용에 익숙하신 분이었으면 좋겠습니다."),
            MemberRequirement(field: "uiux", recruitNumber: 2, requiredSkills: ["photoshop", "Figma", "illustrator"], requirementText: "피그마 사용에 능숙했으면 좋겠습니다."),
            MemberRequirement(field: "pm", recruitNumber: 2, requiredSkills: ["Notion", "Jira", "Slack"], requirementText: "노션 사용에 능숙했으면 좋겠습니다.")
        ],
        tagLimit: ["학생", "취준생"],
        meetingWay: "온라인",
        stage: "기획 중이에요",
        userEmail: ""
    )
}
