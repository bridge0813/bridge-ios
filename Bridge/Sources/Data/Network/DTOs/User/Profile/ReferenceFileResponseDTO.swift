//
//  ReferenceFileDTO.swift
//  Bridge
//
//  Created by 엄지호 on 12/30/23.
//

/// '프로필 조회' 에서 사용되는 DTO
struct ReferenceFileResponseDTO: Decodable {
    let id: Int  // 파일 식별자
    let url: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "fileId"
        case url
        case name = "originFileName"
    }
}

extension ReferenceFileResponseDTO {
    func toEntity() -> ReferenceFile {
        ReferenceFile(id: id, url: url, name: name, data: nil)
    }
}
