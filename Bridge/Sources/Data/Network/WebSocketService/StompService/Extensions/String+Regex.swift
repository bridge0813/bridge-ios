//
//  String+Regex.swift
//  Bridge
//
//  Created by 정호윤 on 11/17/23.
//

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
    
    /// 정규표현식을 사용해 STOMP 프레임에서 JSON 부분만 추출하는 함수
    func extractJsonString() -> String? {
        let pattern = "\\{.*\\}"
        
        if let range = self.range(of: pattern, options: .regularExpression) {
            return String(self[range])
        } else {
            return nil
        }
    }
}
