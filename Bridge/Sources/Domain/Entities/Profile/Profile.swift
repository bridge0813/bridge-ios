//
//  Profile.swift
//  Bridge
//
//  Created by 엄지호 on 12/27/23.
//

import UIKit

struct Profile {
    var updatedImage: UIImage?  // 유저가 수정한 프로필 이미지
    let imageURL: String?
    var name: String
    var introduction: String?
    let fields: [String]
    var fieldTechStacks: [FieldTechStack]
    var carrer: String?
    var links: [String]
    var files: [ReferenceFile]
}

/// 분야와 분야에 맞는 기술 스택
struct FieldTechStack {
    var field: String
    var techStacks: [String]
}

/// 첨부 파일
struct ReferenceFile {
    let url: String
    let name: String
    let identifier: String?
    var data: Data?
}

extension Profile {
    static let onError = Profile(
        updatedImage: nil, 
        imageURL: nil,
        name: "Error",
        introduction: nil,
        fields: [],
        fieldTechStacks: [],
        carrer: nil,
        links: [],
        files: []
    )
}
