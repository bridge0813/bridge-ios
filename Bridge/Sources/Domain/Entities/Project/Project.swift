//
//  Project.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/15.
//

import Foundation

struct Project {
    var title: String
    var description: String
    let dDays: Int
    var deadline: Date
    var startDate: Date?
    var endDate: Date?
    var memberRequirements: [MemberRequirement]
    var applicantRestrictions: [String]
    var progressMethod: String
    var progressStep: String
    let userName: String
    let isBookmarked: Bool
    let isMyProject: Bool
    let totalRecruitNumber: Int
}

extension Project {
    static var onError: Self {
        Project(
            title: "",
            description: "",
            dDays: 0,
            deadline: Date(),
            startDate: nil,
            endDate: nil,
            memberRequirements: [],
            applicantRestrictions: [],
            progressMethod: "",
            progressStep: "",
            userName: "",
            isBookmarked: false,
            isMyProject: false,
            totalRecruitNumber: 0
        )
    }
}

extension Project: Hashable { }
