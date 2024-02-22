//
//  FilteredProjectRequestDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2/5/24.
//

import Foundation

struct FilteredProjectRequestDTO: Encodable {
    let userID: Int
    let field: String
    let techStacks: [String]
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case field = "part"
        case techStacks = "skills"
    }
}
