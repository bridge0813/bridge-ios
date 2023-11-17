//
//  StompEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 11/15/23.
//

import Foundation

protocol StompEndpoint {
    var command: StompRequestCommand { get }
    var headers: StompHeaders? { get }
    var body: Encodable? { get }
    
    func toFrame() -> String
}

extension StompEndpoint {
    func toFrame() -> String {
        var frame = ""
        
        // Command
        frame.append(command.rawValue + "\n")
        
        // Headers
        if let headers {
            for (key, value) in headers {
                frame.append(key + ":" + value + "\n")
            }
        }
        
        // Body
        if let body {
            frame.append("\n")
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            if let jsonData = try? encoder.encode(body),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                frame.append(jsonString)
            }
            
        } else {
            frame.append("\n")
        }
        
        // NULL character
        frame.append("\0")
        
        return frame
    }
}
