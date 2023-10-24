//
//  ErrorAlertConfiguration.swift
//  Bridge
//
//  Created by 정호윤 on 10/24/23.
//

struct ErrorAlertConfiguration {
    let title: String
    var description: String?
}

extension ErrorAlertConfiguration {
    static let unknown = ErrorAlertConfiguration(title: "알 수 없는 에러가 발생했습니다.")
}
