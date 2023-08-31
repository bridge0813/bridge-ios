//
//  Date+Extension.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter.string(from: self)
    }
    
    func calculateDDay(to deadline: Date) -> Int {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: self, to: deadline)   
        return components.day ?? 0
    }
}
