//
//  MessageRepository.swift
//  Bridge
//
//  Created by 정호윤 on 10/22/23.
//

import RxSwift

protocol MessageRepository {
    func observe(chatRoomID: String) -> Observable<[Message]>
}
