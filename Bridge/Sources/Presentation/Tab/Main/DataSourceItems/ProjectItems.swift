//
//  ProjectItems.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/05.
//

import Foundation

enum ProjectItem: Hashable {
    case hot(HotProject)
    case main(Project)
}
