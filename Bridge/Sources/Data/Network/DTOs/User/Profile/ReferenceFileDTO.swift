//
//  ReferenceFileDTO.swift
//  Bridge
//
//  Created by 엄지호 on 12/30/23.
//

struct ReferenceFileDTO: Decodable {
    let url: String
    let fileName: String
}

extension ReferenceFileDTO {
    func toEntity() -> ReferenceFile {
        ReferenceFile(url: url, fileName: fileName)
    }
}
