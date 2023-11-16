//
//  ProjectDetail.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/15.
//

import Foundation

// TODO: - let, var 추후조정
struct ProjectDetail {
    let title: String
    let description: String
    let dDays: Int
    let deadline: Date
    let startDate: Date?
    let endDate: Date?
    let memberRequirements: [MemberRequirement]
    let applicantRestrictions: [String]
    let progressMethod: String
    let progressStep: String
    let userName: String
    let isScrapped: Bool
    let isMyProject: Bool
    let totalRecruitNumber: Int
}

extension ProjectDetail {
    static var onError: Self {
        ProjectDetail(
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
            isScrapped: false,
            isMyProject: false,
            totalRecruitNumber: 0
        )
    }
}

extension ProjectDetail: Hashable { }
