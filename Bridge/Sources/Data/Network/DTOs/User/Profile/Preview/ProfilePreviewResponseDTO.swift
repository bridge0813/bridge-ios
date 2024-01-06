//
//  ProfilePreviewResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/24.
//  Edited by 정호윤 on 2023/12/13.

/// 마이페이지 조회할 때 사용
struct ProfilePreviewResponseDTO: Decodable {
    let profileImage: String?
    let name: String
    let fields: [String]
    let bookmarkedProjectCount: Int
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profilePhoto"
        case name
        case fields = "field"
        case bookmarkedProjectCount = "bookmarkNum"
    }
}

extension ProfilePreviewResponseDTO {
    func toEntity() -> ProfilePreview {
        ProfilePreview(
            profileImage: profileImage,
            name: name,
            fields: fields,
            bookmarkedProjectCount: bookmarkedProjectCount
        )
    }
}

extension ProfilePreviewResponseDTO {
    static let testData = ProfilePreviewResponseDTO(
        profileImage: "",
        name: "정호윤",
        fields: ["iOS", "안드로이드", "프론트엔드", "백엔드", "UI/UX", "BI/BX", "영상/모션", "PM"],
        bookmarkedProjectCount: 10
    )
}
