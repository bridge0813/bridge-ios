//
//  UserRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/25.
//

import RxSwift

protocol UserRepository {
    func fetchProfilePreview() -> Observable<ProfilePreview>
}
