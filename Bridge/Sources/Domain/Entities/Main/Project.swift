//
//  Project.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation

// TODO: - 데이터 구조에 따라 수정필요
struct Project {
    let id: String
    let title: String
    let overview: String
    let dDays: Int
    let dueDate: Date
    let startDate: Date?
    let endDate: Date?
    let memberRequirement: [MemberRequirement]
    let tagLimit: [String]
    let meetingWay: String
    let progressStatus: String
    let userEmail: String
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
