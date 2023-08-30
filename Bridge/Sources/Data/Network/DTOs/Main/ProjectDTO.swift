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
    let fields: [RecruitmentField]
    let requiredFieldTag: [String]
    let requiredStackTag: [String]
    let startDate: Date
    let endDate: Date
    let deadlineDate: Date  // 공고 모집마감 날짜
}

extension ProjectDTO {
    
    func toModel() -> Project {
        let project = Project(
            id: id,
            title: title,
            totalRequiredMembersCount: 0,
            fields: fields,
            dDayCount: Date().calculateDDay(to: deadlineDate),
            requiredFieldTag: requiredFieldTag,
            requiredStackTag: requiredStackTag,
            startDate: startDate.toString(),
            endDate: endDate.toString()
        )
        
        let totalRequiredMembersCount = project.calculateTotalRequiredMembersCount()
        
        return Project(
            id: project.id,
            title: project.title,
            totalRequiredMembersCount: totalRequiredMembersCount,
            fields: project.fields,
            dDayCount: project.dDayCount,
            requiredFieldTag: project.requiredFieldTag,
            requiredStackTag: project.requiredStackTag,
            startDate: project.startDate,
            endDate: project.endDate
        )
    }
}
