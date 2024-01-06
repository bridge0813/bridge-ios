//
//  UpdateProfileRequestDTO.swift
//  Bridge
//
//  Created by 엄지호 on 1/7/24.
//

struct UpdateProfileRequestDTO: Encodable {
    let imageURL: String?
    let name: String
    let introduction: String?
    let fieldTechStacks: [FieldTechStackDTO]
    let carrer: String?
    let links: [String]
    let files: [ReferenceFileDTO]
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "profilePhotoURL"
        case name
        case introduction = "selfIntro"
        case fieldTechStacks = "stacks"
        case carrer
        case links = "refLink"
        case files = "refFile"
    }
}

extension UpdateProfileRequestDTO {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(fieldTechStacks, forKey: .fieldTechStacks)
        try container.encode(links, forKey: .links)
        try container.encode(files, forKey: .files)
        
        // imageURL
        if let imageURL {
            try container.encode(imageURL, forKey: .imageURL)
        } else {
            try container.encodeNil(forKey: .imageURL)
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
