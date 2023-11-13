//
//  MessageRepository.swift
//  Bridge
//
//  Created by 정호윤 on 11/13/23.
//

import RxSwift

protocol MessageRepository {
    func fetchMessages(channelID: String) -> Observable<[Message]>
}
