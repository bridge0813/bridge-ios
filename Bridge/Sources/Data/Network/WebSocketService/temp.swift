////
////  WebSocketService.swift
////  Bridge
////
////  Created by 정호윤 on 10/18/23.
////
//
//import Foundation
//import RxSwift
//
//protocol WebSocketService {
//    /// 웹 소켓 연결
//    func connect(endpoint: Endpoint)
//    
//    /// 웹 소켓 연결 해제
//    func disconnect()
//    
//    /// STOMP 연결 및 구독
//    func subscribe(_ connectEndpoint: StompEndpoint, _ subscribeEndpoint: StompEndpoint) -> Observable<Data>
//    
//    /// STOMP 구독 및 연결 해제
//    func unsubscribe(_ endpoint: StompEndpoint)
//    
//    /// STOMP 메시지 전송
//    func send(_ endpoint: StompEndpoint)
//}
