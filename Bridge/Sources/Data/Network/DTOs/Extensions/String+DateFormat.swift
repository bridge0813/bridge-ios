//
//  String+DateFormat.swift
//  Bridge
//
//  Created by 정호윤 on 11/16/23.
//

import Foundation

extension String {
    /// ISO 8601 형식의 문자열을 "오전/오후 h시 mm분" 형태로 변환하는 함수
    func toDetailedTime() -> String? {
        var isoString = self
        isoString.append("+09:00")  // 표준 시간대 추가
        
        // ISO 8601 형식의 문자열을 Date 객체로 변환
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: isoString) else { return nil }
        
        // Date 객체를 "오전/오후 h시 mm분" 형태로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a h시 mm분"
        
        return dateFormatter.string(from: date)
    }
    
    /// ISO 8601 형식의 문자열을 "오전/오후 h:mm" 형태로 변환하는 함수
    func toSimpleTime() -> String? {
        var isoString = self
        isoString.append("+09:00")  // 표준 시간대 추가
        
        // ISO 8601 형식의 문자열을 Date 객체로 변환
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: isoString) else { return nil }
        
        // Date 객체를 "오전/오후 h시 mm분" 형태로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a h:mm"
        
        return dateFormatter.string(from: date)
    }
    
    /// ISO 8601 형식의 문자열을 "yyyy년 MM월 dd일" 형태로 변환하는 함수
    func toDate() -> String? {
        var isoString = self
        isoString.append("+09:00")  // 표준 시간대 추가
        
        // ISO 8601 형식의 문자열을 Date 객체로 변환
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: isoString) else { return nil }
        
        // Date 객체를 "yyyy년 MM월 dd일" 형태로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        return dateFormatter.string(from: date)
    }
}
