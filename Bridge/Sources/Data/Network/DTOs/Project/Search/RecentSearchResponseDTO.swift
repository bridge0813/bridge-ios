//
//  RecentSearchResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2/6/24.
//

import Foundation

struct RecentSearchResponseDTO: Decodable {
    let searchWordID: Int
    let searchWord: String
    
    enum CodingKeys: String, CodingKey {
        case searchWordID = "searchWordId"
        case searchWord
    }
}

extension RecentSearchResponseDTO {
    func toEntity() {
        
    }
}
