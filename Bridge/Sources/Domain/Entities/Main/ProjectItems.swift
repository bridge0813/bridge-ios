//
//  ProjectItems.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/05.
//

import Foundation

enum ProjectItems {
    case hot(HotProject)
    case main(Project)
}

extension ProjectItems: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .hot(let hotProject):
            hasher.combine("hot")
            hasher.combine(hotProject)
            
        case .main(let project):
            hasher.combine("main")
            hasher.combine(project)
        }
    }
}
