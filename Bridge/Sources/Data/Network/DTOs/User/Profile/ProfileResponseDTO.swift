//
//  ProfileResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 12/30/23.
//

/// 프로필 조회에 사용
struct ProfileResponseDTO: Decodable {
    let imageURL: String?
    let name: String
    let introduction: String?
    let fields: [String]
    let fieldTechStacks: [FieldTechStackDTO]
    let carrer: String?
    let links: [String]
    let files: [ReferenceFileResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "profilePhotoURL"
        case name
        case introduction = "selfIntro"
        case fields
        case fieldTechStacks = "stacks"
        case carrer
        case links = "refLinks"
        case files = "refFiles"
    }
}

extension ProfileResponseDTO {
    func toEntity() -> Profile {
        Profile(
            imageURL: imageURL,
            name: name,
            introduction: introduction,
            fields: fields,
            fieldTechStacks: fieldTechStacks.map { $0.toEntity() },
            carrer: carrer,
            links: links,
            files: files.map { $0.toEntity() }
        )
    }
}

extension ProfileResponseDTO {
    static let testData = ProfileResponseDTO(
        imageURL: "https://firebasestorage.googleapis.com/v0/b/cookingproject-5bf82.appspot.com/o/saveImage1677219882.2262769?alt=media&token=12b9aab3-a0b0-498f-bc81-0e8a8858d481",
        name: "엄지호",
        introduction: "책임감과 성실함을 겸비한 준비된 인재입니다. 사이드 프로젝트는 15번정도 한 경험이 있구요.",
        fields: ["백엔드", "안드로이드", "iOS"],
        fieldTechStacks: [
            FieldTechStackDTO(field: "iOS", techStacks: ["Swift", "Objective_C", "UIKit", "SwiftUI", "RxSwift"]),
            FieldTechStackDTO(field: "안드로이드", techStacks: ["Kotlin", "Java", "Compose"])
//            FieldTechStackDTO(field: "백엔드", techStacks: ["Java", "Javascript", "Python", "TypeScript", "C", "C++", "Kotlin", "Spring"]),
//            FieldTechStackDTO(field: "UI/UX", techStacks: ["photoshop", "illustrator", "indesign"]),
//            FieldTechStackDTO(field: "BI/BX", techStacks: ["photoshop"])
        ],
        carrer: "취준생",
        links: ["https://bridge.naver.comㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ", "https://bridge.naver.com", "https://bridge.naver.com"],
        files: [ReferenceFileResponseDTO(id: 0, url: "", name: "개인 작업물.pdf")]
    )
}
