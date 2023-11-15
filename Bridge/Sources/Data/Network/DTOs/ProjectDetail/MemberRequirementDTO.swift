//
//  MemberRequirementDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/15.
//

import Foundation

struct MemberRequirementDTO: Codable {
    var field: String
    var recruitNumber: Int
    var requiredSkills: [String]
    var requirementText: String
    
    enum CodingKeys: String, CodingKey {
        case field = "recruitPart"
        case recruitNumber = "recruitNum"
        case requiredSkills = "recruitSkill"
        case requirementText = "requirement"
    }
}
