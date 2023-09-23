//
//  SignInUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/13.
//

import RxSwift

// TODO: 로그인 플로우
// 1. 로그인 창에서 "애플 로그인" 버튼 누르면 - view model
// 2. 클라단에서 애플 서버에 요청해서 credential 받아와서 - view model
// 3. 받아온 credential 중 이름, identity token 등 우리 서버에 보내면서 로그인 시도
// 4. 서버에서 또 응답으로 회원가입인지 or 로그인 성공했는지 + 토큰들 등 응답
// 5. 응답에 맞는처리
//     5-1. 로그인: 토큰들 키체인에 저장 -> dismiss
//     5-2. 신규 유저: 토큰들 키체인에 저장 -> 분야 선택 뷰 push

protocol SignInUseCase {
    func signInWithApple(credentials: UserCredentials) -> Single<SignInResult>
}

final class DefaultSignInUseCase: SignInUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func signInWithApple(credentials: UserCredentials) -> Single<SignInResult> {
        authRepository.signInWithApple(credentials: credentials)
    }
}
