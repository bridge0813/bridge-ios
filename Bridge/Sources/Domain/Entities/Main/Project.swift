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
    var overview: String
    var dDays: Int
    var dueDate: Date
    var startDate: Date?
    var endDate: Date?
    var memberRequirement: [MemberRequirement]
    var tagLimit: [String]
    var meetingWay: String
    var progressStatus: String
    var userEmail: String
}

extension Project {
    static var onError: Self {
        Project(
            id: UUID().uuidString,
            title: "",
            overview: "",
            dDays: 0,
            dueDate: Date(),
            startDate: nil,
            endDate: nil,
            memberRequirement: [],
            tagLimit: [],
            meetingWay: "",
            progressStatus: "",
            userEmail: ""
        )
    }
}

extension Project: Hashable { }
