//
//  SearchProjectRequestDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2/7/24.
//


struct SearchProjectRequestDTO: Encodable {
    let userID: Int
    let searchWord: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case searchWord
    }
}
