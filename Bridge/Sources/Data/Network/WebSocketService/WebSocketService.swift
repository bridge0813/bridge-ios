//
//  WebSocketService.swift
//  Bridge
//
//  Created by 정호윤 on 11/17/23.
//

import Foundation

protocol WebSocketService: AnyObject {
    typealias Frame = String
    
    var delegate: WebSocketServiceDelegate? { get set }
    
    func connect(_ endpoint: Endpoint)
    func disconnect()
    
    func write(_ frame: Frame, completion: (() -> Void)?)
}

protocol WebSocketServiceDelegate: AnyObject {
    func webSocketDidConnect()
    func webSocketDidDisconnect()
    
    func webSocketDidReceive(text: String)
}
