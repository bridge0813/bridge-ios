//
//  ApplicantProfile.swift
//  Bridge
//
//  Created by 엄지호 on 12/12/23.
//

/// 지원자 프로필
struct ApplicantProfile {
    let userID: Int
    let imageURL: URLString?
    let name: String
    let fields: [String]
    let career: String?
}

extension ApplicantProfile {
    static let onError = ApplicantProfile(userID: -1, imageURL: nil, name: "오류", fields: [], career: "")
}

extension ApplicantProfile: Hashable { }
