//
//  DefaultAuthRepository.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/13.
//

import RxSwift

final class DefaultAuthRepository: AuthRepository {
    
    private let networkService: NetworkService
    private let tokenStorage: TokenStorage
    
    init(networkService: NetworkService, tokenStorage: TokenStorage) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
    
    func signInWithApple(credentials: UserCredentials) -> Single<SignInResult> {
        let userName = tokenStorage.fetchToken(for: KeychainAccount.userName)
        
        if !credentials.name.isEmpty {  // 이름은 2번째 로그인부터 빈 문자열이 리턴되므로, 빈 문자열 저장하지 않도록 처리
            tokenStorage.saveToken(credentials.name, for: KeychainAccount.userName)
        }
        
        return networkService.signInWithAppleTest(userName: userName, credentials: credentials)
            .flatMap { [weak self] signInResponseDTO in
                // 응답 저장
                self?.tokenStorage.saveToken(signInResponseDTO.accessToken, for: KeychainAccount.accessToken)
                self?.tokenStorage.saveToken(signInResponseDTO.refreshToken, for: KeychainAccount.refreshToken)
                self?.tokenStorage.saveToken(String(signInResponseDTO.userId), for: KeychainAccount.userID)
                
                // SignInResponseDTO를 SignInResult로 매핑
                let result: SignInResult = signInResponseDTO.isRegistered ? .success : .needSignUp
                
                return Single.just(result)
            }
            .catch { _ in
                Single.just(SignInResult.failure)
            }
    }
    
    func signUp(selectedFields: [String]) -> Single<Void> {
        let userID = Int(tokenStorage.fetchToken(for: KeychainAccount.userID) ?? "")
        return networkService.signUpTest(userID: userID, selectedFields: selectedFields)
    }
}
