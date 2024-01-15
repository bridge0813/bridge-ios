//
//  ProfilePreviewResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/24.
//  Edited by 정호윤 on 2023/12/13.

/// 마이페이지 조회할 때 사용
struct ProfilePreviewResponseDTO: Decodable {
    let imageURL: String?
    let name: String
    let fields: [String]
    let bookmarkedProjectCount: Int
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "profilePhoto"
        case name
        case fields = "field"
        case bookmarkedProjectCount = "bookmarkNum"
    }
}

extension ProfilePreviewResponseDTO {
    func toEntity() -> ProfilePreview {
        ProfilePreview(
            imageURL: imageURL,
            name: name,
            fields: fields,
            bookmarkedProjectCount: bookmarkedProjectCount
        )
    }
}

extension ProfilePreviewResponseDTO {
    static let testData = ProfilePreviewResponseDTO(
        imageURL: "https://firebasestorage.googleapis.com/v0/b/cookingproject-5bf82.appspot.com/o/saveImage1677219882.2262769?alt=media&token=12b9aab3-a0b0-498f-bc81-0e8a8858d481",
        name: "정호윤",
        fields: ["iOS", "안드로이드", "프론트엔드", "백엔드", "UI/UX", "BI/BX", "영상/모션", "PM"],
        bookmarkedProjectCount: 10
    )
}
