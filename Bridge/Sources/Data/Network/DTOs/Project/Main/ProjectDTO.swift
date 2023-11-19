//
//  ProjectDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation

// TODO: - 수정필요
struct ProjectDTO: Codable {
    let id: String
    let title: String
    let overview: String
    let dueDate: Date
    let startDate: Date?
    let endDate: Date?
    let recruit: [MemberRequirement]
    let tagLimit: [String]
    let meetingWay: String
    let stage: String
    let userEmail: String
}

extension ProjectDTO {
    func toEntity() -> Project {
        Project(
            id: id,
            title: title,
            description: overview,
            dDays: Date().calculateDDay(to: dueDate),
            deadline: dueDate,
            startDate: startDate,
            endDate: endDate,
            memberRequirements: recruit,
            applicantRestrictions: tagLimit,
            progressMethod: meetingWay,
            progressStep: stage,
            userEmail: userEmail
        )
    }
}

extension ProjectDTO {
    static var projectTestArray: [ProjectDTO] = [
        ProjectDTO(
            id: "1",
            title: "모임 플랫폼 디자이너 구합니다",
            overview: "모임 플랫폼",
            dueDate: Date(),
            startDate: Date(),
            endDate: Date(),
            recruit: [],
            tagLimit: [],
            meetingWay: "온라인",
            stage: "기획 중",
            userEmail: ""
        ),
        ProjectDTO(
            id: "2",
            title: "웹 사이트 디자이너 구해요!!",
            overview: "모임 플랫폼",
            dueDate: Date(),
            startDate: Date(),
            endDate: Date(),
            recruit: [],
            tagLimit: [],
            meetingWay: "온라인",
            stage: "기획 중",
            userEmail: ""
        ),
        ProjectDTO(
            id: "3",
            title: "웹 사이트 디자이너 구해요!!",
            overview: "모임 플랫폼",
            dueDate: Date(),
            startDate: Date(),
            endDate: Date(),
            recruit: [],
            tagLimit: [],
            meetingWay: "온라인",
            stage: "기획 중",
            userEmail: ""
        ),
        ProjectDTO(
            id: "4",
            title: "웹 사이트 디자이너 구해요!!",
            overview: "모임 플랫폼",
            dueDate: Date(),
            startDate: Date(),
            endDate: Date(),
            recruit: [],
            tagLimit: [],
            meetingWay: "온라인",
            stage: "기획 중",
            userEmail: ""
        ),
        ProjectDTO(
            id: "5",
            title: "웹 사이트 디자이너 구해요!!",
            overview: "모임 플랫폼",
            dueDate: Date(),
            startDate: Date(),
            endDate: Date(),
            recruit: [],
            tagLimit: [],
            meetingWay: "온라인",
            stage: "기획 중",
            userEmail: ""
        ),
        ProjectDTO(
            id: "6",
            title: "웹 사이트 디자이너 구해요!!",
            overview: "모임 플랫폼",
            dueDate: Date(),
            startDate: Date(),
            endDate: Date(),
            recruit: [],
            tagLimit: [],
            meetingWay: "온라인",
            stage: "기획 중",
            userEmail: ""
        ),
        ProjectDTO(
            id: "7",
            title: "웹 사이트 디자이너 구해요!!",
            overview: "모임 플랫폼",
            dueDate: Date(),
            startDate: Date(),
            endDate: Date(),
            recruit: [],
            tagLimit: [],
            meetingWay: "온라인",
            stage: "기획 중",
            userEmail: ""
        )
    ]
    
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
