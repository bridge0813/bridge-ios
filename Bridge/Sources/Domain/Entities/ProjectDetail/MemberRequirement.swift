//
//  MemberRequirement.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/17.
//

import Foundation

// TODO: Codable 제거.
struct MemberRequirement: Codable {
    var field: String
    var recruitNumber: Int
    var requiredSkills: [String]
    var requirementText: String
}

extension MemberRequirement: Hashable { }
