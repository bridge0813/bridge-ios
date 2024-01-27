//
//  Data+Multipart.swift
//  Bridge
//
//  Created by 엄지호 on 1/11/24.
//

import Foundation

extension Data {
    mutating func appendFileDataForMultipart(
        _ data: Data,
        fieldName: String,
        fileName: String,
        mimeType: String,
        boundary: String
    ) {
        // 구분자 추가
        append("--\(boundary)\r\n".data(using: .utf8)!)
        
        // 멀티 파트 데이터의 파트에 대한 헤더를 추가
        // name은 데이터를 식별하는 데 사용되는 이름
        // filename은 업로드되는 파일의 이름
        append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        
        // MIME 타입을 명시(확장자가 동일해야 함)
        append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        
        // 실제 이미지 바이너리 데이터를 담고있는 값 추가
        append(data)
        
        // 멀티파트 데이터의 각 파트를 구분(이 파트에서 종료를 의미)
        append("\r\n".data(using: .utf8)!)
    }
}
