//
//  ProjectPreview.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

/// 프로젝트의 간략형
struct ProjectPreview {
    let projectID: Int
    let title: String
    let description: String
    let dDays: Int
    let deadline: String
    let totalRecruitNumber: Int
    let rank: Int
    let deadlineRank: Int
    var isBookmarked: Bool
}

extension ProjectPreview {
    static let onError = ProjectPreview(
        projectID: 0,
        title: "모집글을 불러올 수 없습니다.",
        description: "",
        dDays: 0,
        deadline: "",
        totalRecruitNumber: 0,
        rank: 0,
        deadlineRank: 0,
        isBookmarked: false
    )
}

extension ProjectPreview: Hashable { }
