//
//  BookmarkRequestDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/12/02.
//

struct BookmarkRequestDTO: Encodable {
    let projectID: Int
    
    enum CodingKeys: String, CodingKey {
        case projectID = "projectId"
    }
}
