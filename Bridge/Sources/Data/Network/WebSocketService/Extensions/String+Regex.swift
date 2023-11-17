//
//  String+Regex.swift
//  Bridge
//
//  Created by 정호윤 on 11/17/23.
//

extension String {
    /// 정규표현식을 사용해 STOMP 프레임에서 JSON 부분만 추출하는 함수
    func extractJsonString() -> String? {
        let string = self
        let pattern = "\\{.*\\}"
        
        if let firstIndex = string.range(of: pattern, options: .regularExpression) {
            return String(string[firstIndex])
        } else {
            return nil
        }
    }
}
