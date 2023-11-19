//
//  CreateProject.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/19.
//

struct CreateProject {
    var title: String
    var description: String
    var deadline: String
    var startDate: String?
    var endDate: String?
    var memberRequirements: [MemberRequirement]
    var applicantRestrictions: [String]
    var progressMethod: String
    var progressStep: String
}
