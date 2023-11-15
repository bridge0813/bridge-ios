//
//  StompFrame.swift
//  Bridge
//
//  Created by 정호윤 on 11/14/23.
//

import Foundation

final class StompFrame {
    // MARK: - Property
    private var command: String
    private var headers: StompHeaders
    var body: String?
    
    // MARK: - Init
    init(name: StompRequestCommand, headers: StompHeaders, body: String? = nil) {
        self.command = name.rawValue
        self.headers = headers
        self.body = body
    }
    
    // MARK: - Method
    
}
