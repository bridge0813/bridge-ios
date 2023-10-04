//
//  DispatchQueue+.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/03.
//

import Foundation

extension DispatchQueue {
    static func executeOnMainThread(_ closure: @escaping Closure) {
        // 현재 스레드가 메인 스레드인지 체크
        if Thread.isMainThread {
            closure()
        } else {
            main.async(execute: closure)  // 메인스레드에 비동기적으로 클로저가 실행되도록
        }
    }
}
