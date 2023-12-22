//
//  BridgeAlertResponseDTO.swift
//  Bridge
//
//  Created by 정호윤 on 12/22/23.
//

import Foundation

/// 전체 알림 받아올 때 사용하는 타입
struct BridgeAlertResponseDTO: Decodable {
    let id: String
    let title: String
    let description: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description = "content"
        case date = "time"
    }
}

extension BridgeAlertResponseDTO {
    func toEntity() -> BridgeAlert {
        BridgeAlert(
            id: id,
            title: title,
            description: description,
            date: date.toDate() ?? ""
        )
    }
}

extension BridgeAlertResponseDTO {
    static let testAlerts = [
        BridgeAlertResponseDTO(
            id: "1",
            title: "지원자 등장",
            description: "내 프로젝트에 누군가 지원했어요 지원자 프로필을 확인하고 채팅을 시작해보세요!",
            date: "2023-09-05T09:15:30+00:00"
        )
    ]
}
