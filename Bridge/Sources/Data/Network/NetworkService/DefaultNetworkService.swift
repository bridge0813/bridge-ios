//
//  DefaultNetworkService.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation
import RxSwift

final class DefaultNetworkService: NetworkService {
    func request(_ endpoint: Endpoint) -> Observable<Data> {
        guard let urlRequest = endpoint.toURLRequest() else { return .error(NetworkError.invalidURL) }
        return URLSession.shared.rx.data(request: urlRequest)
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

// MARK: - Auth
extension DefaultNetworkService {
    func signInWithApple(_ credentials: UserCredentials, userName: String?) -> Single<SignInResponseDTO> {
        
        let signInWithAppleRequestDTO = SignInWithAppleRequestDTO(
            name: userName ?? "",
            idToken: String(data: credentials.identityToken ?? Data(), encoding: .utf8) ?? ""
        )
        
        let authEndpoint = AuthEndpoint.signInWithApple(request: signInWithAppleRequestDTO)
        
        return request(authEndpoint)
            .asSingle()
            .flatMap { data in
                if let decodedData = try? JSONDecoder().decode(SignInResponseDTO.self, from: data) {
                    return Single.just(decodedData)
                } else {
                    return Single.error(NetworkError.decodingFailed)
                }
            }
    }
    
    func signInWithAppleTest(_ credentials: UserCredentials, userName: String?) -> Single<SignInResponseDTO> {
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
