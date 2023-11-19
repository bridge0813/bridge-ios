//
//  CreateProject.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/19.
//

struct CreateProject {
    let title: String
    let description: String
    let deadline: String
    let startDate: String?
    let endDate: String?
    let memberRequirements: [MemberRequirement]
    let applicantRestrictions: [String]
    let progressMethod: String
    let progressStep: String
}
