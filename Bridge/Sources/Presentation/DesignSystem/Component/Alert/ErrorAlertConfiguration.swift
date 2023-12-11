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
    static let defaultError = ErrorAlertConfiguration(
        title: "오류",
        description: "오류가 발생했습니다.\n잠시 후 시도해주세요."
    )
    
    static let networkError = ErrorAlertConfiguration(
        title: "네트워크 오류",
        description: "데이터 요청에 실패했습니다.\n현재 사용중인 네트워크 상태를 확인해주세요."
    )
}
