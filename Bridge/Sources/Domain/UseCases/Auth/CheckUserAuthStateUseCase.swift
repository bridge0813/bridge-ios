//
//  CheckUserAuthStateUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/14.
//

import RxSwift

protocol CheckUserAuthStateUseCase {
    func execute() -> Observable<UserAuthState>
}

enum UserAuthState {
    case signedIn
    case notSignedIn
    case error
}

final class DefaultCheckUserAuthStateUseCase: CheckUserAuthStateUseCase {
    
    func execute() -> Observable<UserAuthState> {
        Observable.combineLatest(checkAppleSignInState(), checkKakaoSignInState())
            .map { appleSignInState, kakaoSignInState in
                appleSignInState == .signedIn || kakaoSignInState == .signedIn ? .signedIn : .notSignedIn
            }
    }
}

// TODO: 로그인 상태 체크 로직
// 1. 로그인 기능이 필요한 기능 (프로젝트 지원하기 등)을 시도 - view model
// 2. 로그인 상태 체크 (헤더에 토큰 넣어서 서버로 요청 - 토큰 없으면 빈값이 들어가거나 안들어감)
// 3. 응답 (로그인ok, 회원가입 필요 등)
// 4. 응답 보고 클라에서 적절한 처리
//     4-1. 로그인 된 상태 -> 토큰들 키체인에 저장 후 그대로 진행
//     4-2. 로그인 or 회원가입 필요한 상태 -> 로그인 창 띄우기

private extension DefaultCheckUserAuthStateUseCase {
    private func checkAppleSignInState() -> Observable<UserAuthState> {
        .just(.notSignedIn)  // 예시
    }
    
    private func checkKakaoSignInState() -> Observable<UserAuthState> {
        .just(.notSignedIn)  // 예시
    }
}
