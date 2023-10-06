//
//  AuthRepository.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/13.
//

import RxSwift

protocol AuthRepository {
    func signInWithApple(credentials: UserCredentials) -> Single<SignInResult>
    func signUp(selectedFields: [String]) -> Single<Void>
}
