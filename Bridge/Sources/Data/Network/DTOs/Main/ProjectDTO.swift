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
}
