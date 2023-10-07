//
//  SignUpRequestDTO.swift
//  Bridge
//
//  Created by 정호윤 on 10/6/23.
//

struct SignUpRequestDTO {
    let userID: Int?
    let selectedFields: [String]
}

extension SignUpRequestDTO: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if userID != nil { try container.encode(userID, forKey: .userID) }
        else { try container.encodeNil(forKey: .userID) }  // 필드에 nil 값 명시적으로 인코딩
        
        let userFields = ["fieldName": selectedFields]
        try container.encode(userFields, forKey: .userField)
    }
}

extension SignUpRequestDTO {
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case userField
    }
}
