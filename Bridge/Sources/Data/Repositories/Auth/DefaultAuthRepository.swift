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
    
    func signInWithApple(credentials: UserCredentials) -> Observable<SignInResult> {
        if !credentials.name.isEmpty {  // 이름은 2번째 로그인부터 빈 문자열이 리턴되므로, 빈 문자열 저장하지 않도록 처리
            tokenStorage.save(credentials.name, for: .userName)
        }
        
        let signInWithAppleRequestDTO = SignInWithAppleRequestDTO(
            userName: tokenStorage.get(.userName) ?? invalidToken,
            identityToken: credentials.identityToken ?? invalidToken
        )
        let authEndpoint = AuthEndpoint.signInWithApple(requestDTO: signInWithAppleRequestDTO)
        
        return networkService.request(authEndpoint, interceptor: nil)
            .decode(type: SignInResponseDTO.self, decoder: JSONDecoder())
            .map { [weak self] signInResponseDTO -> SignInResult in
                // 응답 저장
                self?.tokenStorage.save(signInResponseDTO.accessToken, for: .accessToken)
                self?.tokenStorage.save(signInResponseDTO.refreshToken, for: .refreshToken)
                
                return signInResponseDTO.isRegistered ? .success : .needSignUp
            }
            .catchAndReturn(.failure)
    }
    
    func signUp(selectedFields: [String]) -> Observable<SignUpResult> {
        let userID = Int(tokenStorage.get(.userID) ?? invalidToken)
        let signUpRequestDTO = SignUpRequestDTO(userID: userID, selectedFields: selectedFields)
        let authEndpoint = AuthEndpoint.signUp(requestDTO: signUpRequestDTO)

        return networkService.request(authEndpoint, interceptor: AuthInterceptor())
            .map { _ in .success }
            .catchAndReturn(.failure)
    }
}
