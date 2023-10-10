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
    
    func signInWithApple(credentials: UserCredentials) -> Single<SignInResult> {
        if !credentials.name.isEmpty {  // 이름은 2번째 로그인부터 빈 문자열이 리턴되므로, 빈 문자열 저장하지 않도록 처리
            tokenStorage.save(credentials.name, for: .userName)
        }
        
        let signInWithAppleRequestDTO = SignInWithAppleRequestDTO(
            userName: tokenStorage.get(.userName) ?? "",
            identityToken: credentials.identityToken ?? ""
        )
        let authEndpoint = AuthEndpoint.signInWithApple(requestDTO: signInWithAppleRequestDTO)
        
        return networkService.request(authEndpoint)
            .map { [weak self] signInResponseDTO -> SignInResult in
                self?.storeToken(signInResponseDTO)  // 응답 저장
                return signInResponseDTO.isRegistered ? .success : .needSignUp
            }
            .catch { _ in
                Single.just(SignInResult.failure)
            }
    }
    
    private func storeToken(_ signInResponseDTO: SignInResponseDTO) {
        tokenStorage.save(signInResponseDTO.accessToken, for: .accessToken)
        tokenStorage.save(signInResponseDTO.refreshToken, for: .refreshToken)
        tokenStorage.save(String(signInResponseDTO.userId), for: .userID)
    }
    
    func signUp(selectedFields: [String]) -> Single<Void> {
        let userID = Int(tokenStorage.get(.userID) ?? "")
        let signUpRequestDTO = SignUpRequestDTO(userID: userID, selectedFields: selectedFields)
        let authEndpoint = AuthEndpoint.signUp(requestDTO: signUpRequestDTO)

        return networkService.request(authEndpoint)
    }
}
