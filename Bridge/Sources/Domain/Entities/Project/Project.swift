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
    var dDays: Int
    var deadline: Date
    var startDate: Date?
    var endDate: Date?
    var memberRequirements: [MemberRequirement]
    var applicantRestrictions: [String]
    var progressMethod: String
    var progressStep: String
    var userName: String
    var isBookmarked: Bool
    var isMyProject: Bool
    var totalRecruitNumber: Int
}

extension Project {
    static let onError = Project(
        title: "모집글을 불러올 수 없습니다.",
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

extension Project: Hashable { }
