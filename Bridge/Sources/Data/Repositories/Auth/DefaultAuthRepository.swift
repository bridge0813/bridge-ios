//
//  DefaultAuthRepository.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/13.
//

import RxSwift
import Foundation

final class DefaultAuthRepository: AuthRepository {
    
    private let networkService: NetworkService
    private let tokenStorage: TokenStorage
    
    init(networkService: NetworkService, tokenStorage: TokenStorage = KeychainTokenStorage()) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
    
    func signInWithApple(credentials: UserCredentials) -> Observable<Bool> {
        // 이름은 2번째 로그인부터 nil이 리턴되므로, nil을 저장하지 않도록 처리
        if let userName = credentials.userName,
           let givenName = credentials.givenName {
            tokenStorage.save(userName + givenName, for: .userName)
        }
        
        let signInWithAppleRequestDTO = SignInWithAppleRequestDTO(
            userName: tokenStorage.get(.userName),
            identityToken: credentials.identityToken ?? invalidToken,
            fcmToken: tokenStorage.get(.fcmToken)
        )
        let authEndpoint = AuthEndpoint.signInWithApple(requestDTO: signInWithAppleRequestDTO)
        
        return networkService.request(to: authEndpoint, interceptor: nil)
            .decode(type: SignInWithAppleResponseDTO.self, decoder: JSONDecoder())
            .map { [weak self] signInWithAppleResponseDTO in
                self?.tokenStorage.save(String(signInWithAppleResponseDTO.userID), for: .userID)
                self?.tokenStorage.save(signInWithAppleResponseDTO.accessToken, for: .accessToken)
                self?.tokenStorage.save(signInWithAppleResponseDTO.refreshToken, for: .refreshToken)
                
                return signInWithAppleResponseDTO.isRegistered
            }
    }
    
    func signUp(selectedFields: [String]) -> Observable<Void> {
        let userID = Int(tokenStorage.get(.userID))
        let signUpRequestDTO = SignUpRequestDTO(userID: userID, selectedFields: selectedFields)
        let authEndpoint = AuthEndpoint.signUp(requestDTO: signUpRequestDTO)
        
        return networkService.request(to: authEndpoint, interceptor: nil)
            .map { _ in }
    }
    
    func signOut() -> Observable<Void> {
        let userID = tokenStorage.get(.userID)
        let authEndpoint = AuthEndpoint.signOut(userID: userID)
        
        return networkService.request(to: authEndpoint, interceptor: nil)
            .withUnretained(self)
            .do(onNext: { owner, _ in
                owner.tokenStorage.delete(.userID)
                owner.tokenStorage.delete(.accessToken)
                owner.tokenStorage.delete(.refreshToken)
            })
            .map { _ in }
    }
    
    func withdraw() -> Observable<Void> {
        let userID = tokenStorage.get(.userID)
        let authEndpoint = AuthEndpoint.withdrawal(userID: userID)
        
        return networkService.request(to: authEndpoint, interceptor: AuthInterceptor())
            .withUnretained(self)
            .do(onNext: { owner, _ in
                owner.tokenStorage.delete(.userID)
                owner.tokenStorage.delete(.userName)
                owner.tokenStorage.delete(.accessToken)
                owner.tokenStorage.delete(.refreshToken)
            })
            .map { _ in }
    }
}
