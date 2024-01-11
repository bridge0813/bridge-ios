//
//  UpdateProfileRequestDTO.swift
//  Bridge
//
//  Created by 엄지호 on 1/7/24.
//

import Foundation

struct UpdateProfileRequestDTO: Encodable {
    let imageData: Data?
    let name: String
    let introduction: String?
    let fieldTechStacks: [FieldTechStackDTO]
    let carrer: String?
    let links: [String]
    let originalFileIDs: [Int]
    let newFiles: [ReferenceFileRequestDTO]
    
    enum CodingKeys: String, CodingKey {
        case imageData = "photo"
        case name
        case introduction = "selfIntro"
        case fieldTechStacks = "stacks"
        case carrer
        case links = "refLink"
        case originalFileIDs = "fileIds"
        case newfiles = "refFile"
    }
}

extension UpdateProfileRequestDTO {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(fieldTechStacks, forKey: .fieldTechStacks)
        try container.encode(links, forKey: .links)
        try container.encode(originalFileIDs, forKey: .originalFileIDs)
        try container.encode(newFiles, forKey: .newfiles)
        
        // imageData
        if let imageData {
            try container.encode(imageData, forKey: .imageData)
        } else {
            try container.encodeNil(forKey: .imageData)
        }
        
        // introduction
        if let introduction {
            try container.encode(introduction, forKey: .introduction)
        } else {
            try container.encodeNil(forKey: .introduction)
        }
        
        // carrer
        if let carrer {
            try container.encode(carrer, forKey: .carrer)
        } else {
            try container.encodeNil(forKey: .carrer)
        }
    }
}
