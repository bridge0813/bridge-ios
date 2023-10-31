//
//  Project.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation

// TODO: - 데이터 구조에 따라 수정필요
struct Project {
    var id: String
    var title: String
    var description: String
    var dDays: Int
    var deadline: Date
    var startDate: Date?
    var endDate: Date?
    var memberRequirements: [MemberRequirement]
    var applicantRestrictions: [String]
    var progressMethod: String
    var progressStatus: String
    var userEmail: String
}

extension Project {
    static var onError: Self {
        Project(
            id: UUID().uuidString,
            title: "",
            description: "",
            dDays: 0,
            deadline: Date(),
            startDate: nil,
            endDate: nil,
            memberRequirements: [],
            applicantRestrictions: [],
            progressMethod: "",
            progressStatus: "",
            userEmail: ""
        )
    }
}

extension Project: Hashable { }
