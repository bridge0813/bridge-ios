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

extension RecentSearchResponseDTO {
    static var testArray: [RecentSearchResponseDTO] = [
        RecentSearchResponseDTO(searchWordID: 0, searchWord: "디자인"),
        RecentSearchResponseDTO(searchWordID: 1, searchWord: "디자이너"),
        RecentSearchResponseDTO(searchWordID: 2, searchWord: "개발자"),
        RecentSearchResponseDTO(searchWordID: 3, searchWord: "기획자"),
        RecentSearchResponseDTO(searchWordID: 4, searchWord: "브릿지")
    ]
}
