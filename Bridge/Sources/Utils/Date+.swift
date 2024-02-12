//
//  Date+Extension.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation

extension Date {
    func toISO8601String() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 9 * 3600) // KST, +09:00
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // 필요에 따라 옵션 조정
        return formatter.string(from: self)
    }
    
    /// Date 타입을 원하는 포맷에 맞게 String 타입으로 전환
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    /// 현재  Date로부터 1년 후의 Date를 계산해주는 메서드
    func calculateMaximumDate() -> Date {
        let calendar = Calendar.current
        guard let maximumDate = calendar.date(byAdding: .year, value: 1, to: self) else { return Date() }

        return maximumDate
    }
    
    func calculateDDay(to deadline: Date) -> Int {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: self, to: deadline)   
        return components.day ?? 0
    }
}
