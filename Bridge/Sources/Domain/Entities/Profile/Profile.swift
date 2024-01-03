//
//  Profile.swift
//  Bridge
//
//  Created by 엄지호 on 12/27/23.
//

struct Profile {
    let imageURL: String?
    let name: String
    let introduction: String?
    let fields: [String]
    var fieldTechStacks: [FieldTechStack]
    let carrer: String?
    let links: [String]
    let files: [ReferenceFile]
}

/// 분야와 분야에 맞는 기술 스택
struct FieldTechStack {
    var field: String
    var techStacks: [String]
}

/// 첨부 파일
struct ReferenceFile {
    let url: String
    let fileName: String
}

extension Profile {
    static let onError = Profile(
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
