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
    let title: String
    let numberOfRecruits: Int                   // 총 모집 인원
    let recruitmentField: [String]              // 모집 분야
    let techStackTags: [String]                 // 기술 스택 태그
    let dDays: Int                              // 공고 마감일까지 D-Day
    let startDate: String                       // 프로젝트 시작일
    let endDate: String                         // 프로젝트 마감일
}

extension Project {
    static var onError: Self {
        Project(
            id: UUID().uuidString,
            title: "오류",
            numberOfRecruits: 0,
            recruitmentField: [],
            techStackTags: [],
            dDays: 0,
            startDate: "",
            endDate: ""
        )
    }
}

extension Project: Hashable { }
