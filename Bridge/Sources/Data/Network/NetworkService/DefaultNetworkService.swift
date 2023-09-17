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
        return URLSession.shared.rx.data(request: urlRequest).asObservable()
    }
    
    // MARK: - For test
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

// MARK: - For test (auth)
extension DefaultNetworkService {
    func signInWithAppleCredentials(_ credentials: UserCredentials) -> Observable<SignInResult> {
        // 1. user credentials -map-> DTO
        // 2. request
        // 3. response handle
        .just(.needSignUp)
    }
    
    func checkUserAuthState() -> Observable<UserAuthState> {
        .just(.signedIn)
    }
}
