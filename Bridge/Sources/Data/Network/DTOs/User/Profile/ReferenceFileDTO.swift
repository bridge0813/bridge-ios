//
//  ReferenceFileDTO.swift
//  Bridge
//
//  Created by 엄지호 on 12/30/23.
//

struct ReferenceFileDTO: Codable {
    let url: String
    let fileName: String
    let identifier: String  // 파일 식별자
}

extension ReferenceFileDTO {
    func toEntity() -> ReferenceFile {
        ReferenceFile(url: url, name: fileName, identifier: identifier, data: nil)
    }
}
