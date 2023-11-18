//
//  WebSocketService.swift
//  Bridge
//
//  Created by 정호윤 on 11/17/23.
//

protocol WebSocketService: AnyObject {
    typealias WebSocketFrame = String
    
    var delegate: WebSocketServiceDelegate? { get set }
    
    func connect(to endpoint: Endpoint)
    func disconnect()
    
    func write(_ frame: WebSocketFrame, completion: (() -> Void)?)
}
