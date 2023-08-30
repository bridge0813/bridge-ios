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
    let totalRequiredMembersCount: Int // 모집 인원
    let fields: [RecruitmentField] // 모집 분야
    let dDayCount: Int // 공고 마감일까지 D-Day
    let requiredFieldTag: [String] // 모집 분야 tag
    let requiredStackTag: [String] // 기술 스택 tag
    let startDate: String // 프로젝트 시작일
    let endDate: String // 프로젝트 마감일
}

extension Project {
    static var onError: Self {
        Project(
            id: UUID().uuidString,
            title: "오류",
            totalRequiredMembersCount: 0,
            fields: [],
            dDayCount: 0,
            requiredFieldTag: [],
            requiredStackTag: [],
            startDate: "",
            endDate: ""
        )
    }
}
