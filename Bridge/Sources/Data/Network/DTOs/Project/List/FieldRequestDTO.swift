//
//  FieldRequestDTO.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/27.
//

/// 특정 분야에 맞는 모집글 조회를 위한 RequestDTO
struct FieldRequestDTO: Encodable {
    let field: String
    
    enum CodingKeys: String, CodingKey {
        case field = "part"
    }
}
