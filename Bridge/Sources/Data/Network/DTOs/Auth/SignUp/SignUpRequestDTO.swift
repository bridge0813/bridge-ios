//
//  SignUpRequestDTO.swift
//  Bridge
//
//  Created by 정호윤 on 10/6/23.
//

struct SignUpRequestDTO: Encodable {
    let userID: Int?
    let selectedFields: [String]
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case userField
    }
}

extension SignUpRequestDTO {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let userID = userID {
            try container.encode(userID, forKey: .userID)
        } else {
            try container.encodeNil(forKey: .userID)  // null 값 명시적으로 인코딩
        }
        
        try container.encode(selectedFields, forKey: .userField)
    }
}

