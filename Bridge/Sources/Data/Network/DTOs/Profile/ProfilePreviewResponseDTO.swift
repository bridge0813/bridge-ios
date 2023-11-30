//
//  ProfilePreviewResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/24.
//

/// MyPage를 조회할 때 사용되는 Response Body
struct ProfilePreviewResponseDTO: Decodable {
    let profileImage: String?
    let fields: [String]
    let bookmarkNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case fields = "field"
        case profileImage = "profilePhoto"
        case bookmarkNumber = "bookmarkNum"
    }
}

extension ProfilePreviewResponseDTO {
    func toEntity() -> ProfilePreview {
        ProfilePreview(profileImage: profileImage, fields: fields, bookmarkNumber: bookmarkNumber)
    }
}
