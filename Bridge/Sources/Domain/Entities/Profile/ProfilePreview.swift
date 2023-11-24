//
//  ProfilePreview.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/25.
//

struct ProfilePreview {
    let profileImage: String
    let field: [String]
    let bookmarkNumber: Int
}

extension ProfilePreview {
    static let onError = ProfilePreview(profileImage: "", field: [], bookmarkNumber: 0)
}
