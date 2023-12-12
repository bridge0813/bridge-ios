//
//  ProfilePreviewResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/24.
//

/// MyPage를 조회할 때 사용되는 Response Body
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
        fields: ["iOS", "UI/UX"],
        bookmarkedProjectCount: 10
    )
}
