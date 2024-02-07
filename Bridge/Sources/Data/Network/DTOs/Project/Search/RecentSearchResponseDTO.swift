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
        RecentSearchResponseDTO(searchWordID: 4, searchWord: "브릿지"),
        RecentSearchResponseDTO(searchWordID: 5, searchWord: "엄지호"),
        RecentSearchResponseDTO(searchWordID: 6, searchWord: "iOS"),
        RecentSearchResponseDTO(searchWordID: 7, searchWord: "zzzzz"),
        RecentSearchResponseDTO(searchWordID: 8, searchWord: "ㅎㅎㅎㅎ"),
        RecentSearchResponseDTO(searchWordID: 9, searchWord: "하하하하하"),
        RecentSearchResponseDTO(searchWordID: 10, searchWord: "호호호호홓"),
        RecentSearchResponseDTO(searchWordID: 11, searchWord: "키키키키키")
    ]
}
