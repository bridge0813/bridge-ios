//
//  ApplicantProfileResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 12/26/23.
//

/// 지원자 목록을 조회할 때 사용되는 DTO
struct ApplicantProfileResponseDTO: Decodable {
    let userID: Int
    let imageURL: String?
    let name: String
    let fields: [String]
    let career: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case imageURL = "image"
        case name
        case fields
        case career
    }
}

extension ApplicantProfileResponseDTO {
    func toEntity() -> ApplicantProfile {
        ApplicantProfile(userID: userID, imageURL: imageURL, name: name, fields: fields, career: career)
    }
}

extension ApplicantProfileResponseDTO {
    static var testArray: [ApplicantProfileResponseDTO] = [
        ApplicantProfileResponseDTO(
            userID: 0,
            imageURL: "https://firebasestorage.googleapis.com/v0/b/cookingproject-5bf82.appspot.com/o/saveImage1677219882.2262769?alt=media&token=12b9aab3-a0b0-498f-bc81-0e8a8858d481",
            name: "엄지호",
            fields: ["iOS", "UIUX"],
            career: "취준생"
        ),
        ApplicantProfileResponseDTO(userID: 1, imageURL: nil, name: "정호윤", fields: ["iOS", "UIUX"], career: "학생"),
        ApplicantProfileResponseDTO(userID: 2, imageURL: nil, name: "고경", fields: ["영상/모션", "UIUX"], career: "취준생"),
        ApplicantProfileResponseDTO(userID: 3, imageURL: nil, name: "김교연", fields: ["BIBX", "UIUX"], career: "취준생"),
        ApplicantProfileResponseDTO(userID: 4, imageURL: nil, name: "이지민", fields: ["백엔드", "PM"], career: "학생"),
        ApplicantProfileResponseDTO(userID: 5, imageURL: nil, name: "이규현", fields: ["프론트엔드", "백엔드"], career: "취준생")
    ]
}
