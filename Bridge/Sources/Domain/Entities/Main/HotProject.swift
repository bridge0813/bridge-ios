//
//  HotProject.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/03.
//

import Foundation

struct HotProject {
    let id: String
    let title: String
    let numberOfRecruits: Int
    let dDays: Int
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
