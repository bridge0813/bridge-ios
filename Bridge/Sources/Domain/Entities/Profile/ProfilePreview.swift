//
//  ProfilePreview.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/25.
//

struct ProfilePreview {
    let imageURL: URLString?
    let name: String
    let fields: [String]
    let bookmarkedProjectCount: Int
}

extension ProfilePreview {
    static let onError = ProfilePreview(
        imageURL: "",
        name: "",
        fields: [],
        bookmarkedProjectCount: 0
    )
}
