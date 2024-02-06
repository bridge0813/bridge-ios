//
//  RecentSearchResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2/6/24.
//


struct RecentSearchResponseDTO: Decodable {
    let searchWordID: Int
    let searchWord: String
    
    enum CodingKeys: String, CodingKey {
        case searchWordID = "searchWordId"
        case searchWord
    }
}

extension RecentSearchResponseDTO {
    func toEntity() -> RecentSearch {
        RecentSearch(searchWordID: searchWordID, searchWord: searchWord)
    }
}
