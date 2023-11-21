//
//  String+Regex.swift
//  Bridge
//
//  Created by 정호윤 on 11/17/23.
//

// TODO: 문자열 가공 split 등으로 수정 후 json serialization 사용 (정규 표현식 x)
extension String {
    /// 정규표현식을 사용해 STOMP 프레임에서 커맨드를 추출하는 함수
    func extractCommand(_ command: StompResponseCommand) -> String? {
        let pattern = "^\(command.rawValue)"
        
        if let range = self.range(of: pattern, options: [.regularExpression]) {
            return String(self[range])
        } else {
            return nil
        }
    }
    
    /// 정규표현식을 사용해 STOMP 프레임에서 JSON 부분만 추출하는 함수 (단일 메시지만 오는 경우)
    func extractJsonString() -> String? {
        let pattern = "\\{.*?\\}"
        
        if let range = self.range(of: pattern, options: .regularExpression) {
            return String(self[range])
        } else {
            return nil
        }
    }
    
    /// 정규표현식을 사용해 STOMP 프레임에서 JSON  배열 부분만 추출하는 함수 (메시지의 배열이 오는 경우)
    func extractJsonArrayString() -> String? {
        let pattern = "\\[.*?\\]"
        
        if let range = self.range(of: pattern, options: .regularExpression) {
            return String(self[range])
        } else {
            return nil
        }
    }
}
