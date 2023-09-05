//
//  ProjectItems.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/05.
//

import Foundation

enum ProjectItems {
    case hotProject(HotProject)
    case project(Project)
}

extension ProjectItems: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .hotProject(let hotProject):
            hasher.combine("hotProject")
            hasher.combine(hotProject)
            
        case .project(let project):
            hasher.combine("project")
            hasher.combine(project)
        }
    }
}
