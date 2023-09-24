//
//  ProjectDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation

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
    func toModel() -> Project {
        Project(
            id: id,
            title: title,
            description: overview,
            dDays: Date().calculateDDay(to: dueDate),
            recruitmentDeadline: dueDate,
            startDate: startDate,
            endDate: endDate,
            memberRequirements: recruit,
            applicantRestrictions: tagLimit,
            progressMethod: meetingWay,
            progressStatus: stage,
            userEmail: userEmail
        )
    }
}

extension ProjectDTO {
    static var projectTestArray = [
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
        )
    ]
    
    static var hotProjectTestArray = [
        ProjectDTO(
            id: "1Hot",
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
            id: "2Hot",
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
            id: "3Hot",
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
            id: "4Hot",
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
            id: "5Hot",
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
}
