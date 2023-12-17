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
    let isBookmarked: Bool
    let isMyProject: Bool
    
    enum CodingKeys: String, CodingKey {
        case title, startDate, endDate, userName, isMyProject
        case description = "overview"
        case deadline = "dueDate"
        case memberRequirements = "recruit"
        case applicantRestrictions = "tagLimit"
        case progressMethod = "meetingWay"
        case progressStep = "stage"
        case isBookmarked = "scrap"
    }
}

extension ProjectDetailDTO {
    func toEntity() -> Project {
        Project(
            title: title,
            description: description,
            dDays: Date().calculateDDay(to: deadline.toDate(with: "yyyy-MM-dd'T'HH:mm:ss")),
            deadline: deadline.toDate(with: "yyyy-MM-dd'T'HH:mm:ss"),
            startDate: startDate?.toDate(with: "yyyy-MM-dd'T'HH:mm:ss"),
            endDate: endDate?.toDate(with: "yyyy-MM-dd'T'HH:mm:ss"),
            memberRequirements: memberRequirements.map { $0.toEntity() },
            applicantRestrictions: applicantRestrictions,
            progressMethod: progressMethod,
            progressStep: progressStep,
            userName: userName,
            isBookmarked: isBookmarked,
            isMyProject: isMyProject,
            totalRecruitNumber: memberRequirements.reduce(0) { partialResult, requirement in
                return partialResult + requirement.recruitNumber
            }
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
    static var testData = ProjectDetailDTO(
        title: "사이드 프젝으로 IOS앱을 같이 구현할 팀원을 구하고 있어요~",
        description: "안녕하세요 기획부터 앱 출시까지 함께하실 팀원을 모집합니다! 현재 인원은 총 3명입니다. 저희는 개발자, 디자이너, 기횟들이 프로젝트나 스터디 모집을 쉽고 효과적으로 할 수 있게 돕는 IOS앱입니다. 현재는 다른 플랫폼과 차별화된 기능에 대한 기획정도만 마쳐진 상황이며, 추가적으로 더 진행될 예정입니다!",
        deadline: "2023-11-27T21:37:19",
        startDate: "2023-12-01T21:37:19",
        endDate: "2024-04-01T21:37:19",
        memberRequirements: [
            MemberRequirementDTO(field: "IOS", recruitNumber: 2, requiredSkills: ["Swift", "UIKit", "SwiftUI", "RxSwift", "RxCocoa"], requirementText: "스위프트 사용에 익숙하신 분이었으면 좋겠습니다."),
            MemberRequirementDTO(field: "AOS", recruitNumber: 6, requiredSkills: ["Kotlin", "Java", "Compose", "RxJava"], requirementText: "Kotilin카카카카카카카카카키키키키키키키키키키키키키키키키키키니니니니니니니니닌니니니니니로로로로로로로"),
            MemberRequirementDTO(field: "FRONTEND", recruitNumber: 3, requiredSkills: ["Javascript", "TypeScript"], requirementText: "Javascript 사용에 능숙했으면 좋겠습니다."),
            MemberRequirementDTO(field: "BACKEND", recruitNumber: 4, requiredSkills: ["Hibernate", "WebRTC", "MongoDB"], requirementText: "Hibernate, WebRTC, MongoDB 사용에 능숙했으면 좋겠습니다."),
            MemberRequirementDTO(field: "UIUX", recruitNumber: 4, requiredSkills: ["photoshop", "Figma", "illustrator"], requirementText: "피그마 사용에 능숙했으면 좋겠습니다."),
            MemberRequirementDTO(field: "BIBX", recruitNumber: 6, requiredSkills: ["photoshop", "Figma"], requirementText: "피그마 사용에 능숙했으면 좋겠습니다."),
            MemberRequirementDTO(field: "VIDEOMOTION", recruitNumber: 7, requiredSkills: ["photoshop"], requirementText: "photoshop 사용에 능숙했으면 좋겠습니다."),
            MemberRequirementDTO(field: "PM", recruitNumber: 9, requiredSkills: ["Notion", "Jira", "Slack"], requirementText: "노션 사용에 능숙했으면 좋겠습니다.")
        ],
        applicantRestrictions: ["학생", "취준생"],
        progressMethod: "온라인",
        progressStep: "기획 중이에요",
        userName: "",
        isBookmarked: true,
        isMyProject: false
    )
}
