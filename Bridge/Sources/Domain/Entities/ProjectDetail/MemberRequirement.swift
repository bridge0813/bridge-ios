//
//  MemberRequirement.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/17.
//

import Foundation

struct MemberRequirement {
    var field: String
    var recruitNumber: Int
    var requiredSkills: [String]
    var requirementText: String
}

extension MemberRequirement: Hashable { }
