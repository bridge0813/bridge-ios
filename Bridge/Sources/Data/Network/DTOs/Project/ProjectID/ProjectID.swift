//
//  ProjectID.swift
//  Bridge
//
//  Created by 엄지호 on 12/15/23.
//

// 서버와 projectID를 주고 받을 때 사용되는 DTO
struct ProjectIDDTO: Codable {
    let projectID: Int
    
    enum CodingKeys: String, CodingKey {
        case projectID = "projectId"
    }
}
