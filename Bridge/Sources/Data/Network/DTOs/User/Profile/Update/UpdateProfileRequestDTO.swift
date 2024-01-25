//
//  UpdateProfileRequestDTO.swift
//  Bridge
//
//  Created by 엄지호 on 1/7/24.
//

import Foundation

struct UpdateProfileRequestDTO: Encodable {
    let name: String
    let introduction: String?
    let career: String?
    let fieldTechStacks: [FieldTechStackDTO]
    let links: [String]
    let originalFileIDs: [Int]
    
    enum CodingKeys: String, CodingKey {
        case name
        case introduction = "selfIntro"
        case career
        case fieldTechStacks = "fieldAndStacks"
        case links = "refLinks"
        case originalFileIDs = "fileIds"
    }
}

extension UpdateProfileRequestDTO {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(fieldTechStacks, forKey: .fieldTechStacks)
        try container.encode(links, forKey: .links)
        try container.encode(originalFileIDs, forKey: .originalFileIDs)
        
        // introduction
        if let introduction {
            try container.encode(introduction, forKey: .introduction)
        } else {
            try container.encodeNil(forKey: .introduction)
        }
        
        // carrer
        if let career {
            try container.encode(career, forKey: .career)
        } else {
            try container.encodeNil(forKey: .career)
        }
    }
}
