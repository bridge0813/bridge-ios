//
//  Stomp.swift
//  Bridge
//
//  Created by 정호윤 on 11/14/23.
//

enum StompRequestCommand: String {
    case connect = "CONNECT"
    case send = "SEND"
    case subscribe = "SUBSCRIBE"
    case unsubscribe = "UNSUBSCRIBE"
    case begin = "BEGIN"
    case commit = "COMMIT"
    case abort = "ABORT"
    case ack = "ACK"
    case nack = "NACK"
    case disconnect = "DISCONNECT"
}

typealias StompHeaders = [String: String]

enum StompHeaderKey: String {
    case id = "id"
    case host = "host"
    case receipt = "receipt"
    case session = "session"
    case receiptID = "receipt-id"
    case messageID = "message-id"
    case destination = "destination"
    case contentLength = "content-length"
    case contentType = "content-type"
    case ack = "ack"
    case transaction = "transaction"
    case subscription = "subscription"
    case disconnected = "disconnected"
    case heartbeat = "heart-beat"
    case acceptVersion = "accept-version"
    case message = "message"
}

enum StompResponseCommand: String {
    case connected = "CONNECTED"
    case message = "MESSAGE"
    case receipt = "RECEIPT"
    case error = "ERROR"
}
