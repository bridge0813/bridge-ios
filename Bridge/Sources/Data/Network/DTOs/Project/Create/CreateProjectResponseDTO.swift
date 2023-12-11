//
//  CreateProjectResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/23.
//

struct CreateProjectResponseDTO: Decodable {
    let projectID: Int
    
    enum CodingKeys: String, CodingKey {
        case projectID = "projectId"
    }
}
