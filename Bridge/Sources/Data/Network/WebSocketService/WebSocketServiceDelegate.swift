//
//  WebSocketServiceDelegate.swift
//  Bridge
//
//  Created by 정호윤 on 11/18/23.
//

import Foundation

protocol WebSocketServiceDelegate: AnyObject {
    func webSocketDidConnect()
    func webSocketDidDisconnect()
    
    func webSocketDidReceive(text: String)
    func webSocketDidReceive(data: Data)
}
