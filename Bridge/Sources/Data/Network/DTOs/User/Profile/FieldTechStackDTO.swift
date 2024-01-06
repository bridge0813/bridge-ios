//
//  FieldTechStackDTO.swift
//  Bridge
//
//  Created by 엄지호 on 12/30/23.
//

struct FieldTechStackDTO: Codable {
    let field: String
    let techStacks: [String]
}

extension FieldTechStackDTO {
    func toEntity() -> FieldTechStack {
        FieldTechStack(field: field, techStacks: techStacks)
    }
}
