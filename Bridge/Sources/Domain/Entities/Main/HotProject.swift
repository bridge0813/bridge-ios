//
//  HotProject.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/03.
//

import Foundation

struct HotProject {
    var id: String
    let title: String
    let numberOfRecruits: Int                   // 총 모집 인원
    let dDays: Int                              // 공고 마감일까지 D-Day
}

extension HotProject {
    static var onError: Self {
        HotProject(
            id: UUID().uuidString,
            title: "오류",
            numberOfRecruits: 0,
            dDays: 0
        )
    }
}

extension HotProject: Hashable { }
