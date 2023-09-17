//
//  MemberRequirement.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/17.
//

import Foundation

struct MemberRequirement: Codable {
    var part: String
    var num: Int
    var skills: [String]
    var requirement: String
}

extension MemberRequirement: Hashable { }
