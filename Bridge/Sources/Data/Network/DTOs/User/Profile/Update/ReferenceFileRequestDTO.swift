//
//  ReferenceFileRequestDTO.swift
//  Bridge
//
//  Created by 엄지호 on 1/10/24.
//

import Foundation

/// '프로필 수정' 에서 파일을 업로드하기 위해 사용되는 DTO
struct ReferenceFileRequestDTO: Encodable {
    let url: String
    let name: String
    let data: Data  // 파일 바이너리 데이터
}
