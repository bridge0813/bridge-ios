//
//  ApplicantProfileResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 12/26/23.
//

/// 지원자 목록을 조회할 때 사용되는 DTO
struct ApplicantProfileResponseDTO: Decodable {
    let userID: Int
    let name: String
    let fields: [String]
    let career: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case name
        case fields
        case career
    }
}

extension ApplicantProfileResponseDTO {
    func toEntity() -> ApplicantProfile {
        ApplicantProfile(userID: userID, name: name, fields: fields, career: career)
    }
}

extension ApplicantProfileResponseDTO {
    static var testArray: [ApplicantProfileResponseDTO] = [
        ApplicantProfileResponseDTO(userID: 0, name: "엄지호", fields: ["iOS", "UIUX"], career: "취준생"),
        ApplicantProfileResponseDTO(userID: 1, name: "정호윤", fields: ["iOS", "UIUX"], career: "학생"),
        ApplicantProfileResponseDTO(userID: 2, name: "고경", fields: ["영상/모션", "UIUX"], career: "취준생"),
        ApplicantProfileResponseDTO(userID: 3, name: "김교연", fields: ["BIBX", "UIUX"], career: "취준생"),
        ApplicantProfileResponseDTO(userID: 4, name: "이지민", fields: ["백엔드", "PM"], career: "학생"),
        ApplicantProfileResponseDTO(userID: 5, name: "이규현", fields: ["프론트엔드", "백엔드"], career: "취준생")
    ]
}
