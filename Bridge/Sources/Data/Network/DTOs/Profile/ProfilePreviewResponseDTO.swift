//
//  ProfilePreviewResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/24.
//

/// MyPage를 조회할 때 사용되는 Response Body
struct ProfilePreviewResponseDTO: Decodable {
    let profileImage: String?
    let field: [String]
    let bookmarkNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case field
        case profileImage = "profilePhoto"
        case bookmarkNumber = "bookmarkNum"
    }
}

extension ProfilePreviewResponseDTO {
    func toEntity() -> ProfilePreview {
        ProfilePreview(profileImage: profileImage, field: field, bookmarkNumber: bookmarkNumber)
    }
}
