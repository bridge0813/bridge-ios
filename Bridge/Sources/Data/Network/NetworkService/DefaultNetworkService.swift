//
//  DefaultNetworkService.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation
import RxSwift

final class DefaultNetworkService: NetworkService {
    func request(_ endpoint: Endpoint) -> Observable<(HTTPURLResponse, Data)> {
        guard let urlRequest = endpoint.toURLRequest() else { return .error(NetworkError.invalidURL) }
        return URLSession.shared.rx.response(request: urlRequest)
            .map { ($0.response, $0.data) }
    }
}

// MARK: - For test
extension DefaultNetworkService {
    func requestTestChatRooms() -> Observable<[ChatRoomDTO]> {
        Observable.just(ChatRoomDTO.testArray)
    }
    
    func leaveChatRoom(id: String) -> Single<Void> {
        Single.create { single in
            
            if let index = ChatRoomDTO.testArray.firstIndex(where: { $0.id == id }) {
                ChatRoomDTO.testArray.remove(at: index)
                single(.success(()))
            } else {
                single(.failure(NetworkError.unknown))
            }
            
            return Disposables.create()
        }
    }
    
    func requestTestProjectsData() -> Observable<[ProjectDTO]> {
        Observable.just(ProjectDTO.projectTestArray)
    }
    
    func requestTestHotProjectsData() -> Observable<[ProjectDTO]> {
        Observable.just(ProjectDTO.hotProjectTestArray)
    }
}

// MARK: - Sign in
extension DefaultNetworkService {
    func signInWithApple(userName: String?, credentials: UserCredentials) -> Single<SignInResponseDTO> {
        let signInWithAppleRequestDTO = SignInWithAppleRequestDTO(
            name: userName ?? "",
            idToken: String(data: credentials.identityToken ?? Data(), encoding: .utf8) ?? ""
        )
        
        let authEndpoint = AuthEndpoint.signInWithApple(request: signInWithAppleRequestDTO)
        
        // TODO: http code 처리
        return request(authEndpoint).asSingle()
            .flatMap { _, data in
                if let decodedData = try? JSONDecoder().decode(SignInResponseDTO.self, from: data) {
                    return .just(decodedData)
                } else {
                    return .error(NetworkError.decodingFailed)
                }
            }
    }
    
    func signInWithAppleTest(userName: String?, credentials: UserCredentials) -> Single<SignInResponseDTO> {
        Single.just(
            SignInResponseDTO(
                grantType: "Bearer",
                accessToken: "accessToken",
                refreshToken: "refreshToken",
                email: "example@me.com",
                isRegistered: false,
                userId: 1
            )
        )
    }
}

// MARK: - Sign up
extension DefaultNetworkService {
    
    func signUp(userID: Int?, selectedFields: [String]) -> Single<Void> {
        let signUpRequestDTO = SignUpRequestDTO(userID: userID, selectedFields: selectedFields)
        let authEndpoint = AuthEndpoint.signUp(request: signUpRequestDTO)
        
        return request(authEndpoint).asSingle()
            .flatMap { httpResponse, _ in
                if httpResponse.statusCode == 200 { return .just(()) }
                else { return .error(NetworkError.statusCode(httpResponse.statusCode))}
            }
    }
    
    func signUpTest(userID: Int?, selectedFields: [String]) -> Single<Void> {
        .just(())
    }
}
