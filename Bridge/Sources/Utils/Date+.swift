//
//  Date+Extension.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
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
