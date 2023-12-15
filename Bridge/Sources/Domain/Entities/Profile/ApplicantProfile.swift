//
//  ApplicantProfile.swift
//  Bridge
//
//  Created by 엄지호 on 12/12/23.
//

/// 지원자 프로필
struct ApplicantProfile {
    let userID: Int
    let name: String
    let fields: [String]
    let career: String
}

extension ApplicantProfile {
    static let onError = ApplicantProfile(userID: -1, name: "오류", fields: [], career: "")
}

extension ApplicantProfile: Hashable { }
