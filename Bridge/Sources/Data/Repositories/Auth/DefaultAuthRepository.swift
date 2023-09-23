//
//  DefaultAuthRepository.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/13.
//

import RxSwift

// 여러번 호출되는 문제도 해결해야할듯
final class DefaultAuthRepository: AuthRepository {
    
    private let networkService: NetworkService
    private let tokenStorage: TokenStorage
    
    init(networkService: NetworkService, tokenStorage: TokenStorage) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
    
    func signInWithApple(credentials: UserCredentials) -> Single<SignInResult> {
        
        let userName = tokenStorage.fetchToken(for: KeychainAccount.userName)
        
        if credentials.name.isEmpty {  // 이름은 2번째 로그인부터 빈 문자열이 리턴되므로, 빈 문자열 저장하지 않도록 처리
            tokenStorage.saveToken(credentials.name, for: KeychainAccount.userID)
        }
        
        return networkService.signInWithApple(credentials, userName: userName)
            .flatMap { [weak self] signInResponseDTO in
                // 응답으로 받은 토큰을 토큰 저장소에 저장
                self?.tokenStorage.saveToken(signInResponseDTO.accessToken, for: KeychainAccount.accessToken)
                self?.tokenStorage.saveToken(signInResponseDTO.refreshToken, for: KeychainAccount.refreshToken)
                
                // SignInResponseDTO를 SignInResult로 매핑
                let result: SignInResult = signInResponseDTO.isRegistered ? .success : .needSignUp
                
                return Single.just(result)
            }
    }
}
