//
//  DefaultNetworkService.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation
import RxSwift

final class DefaultNetworkService: NetworkService {
    
    func request(_ endpoint: Endpoint) -> Single<Void> {
        Single.create { single in
            guard let urlRequest = endpoint.toURLRequest() else {
                single(.failure(NetworkError.invalidURL))
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] _, response, error in
                guard let result = self?.handleResponse(response, error: error) else { return }
                
                switch result {
                case .success:
                    single(.success(()))
                    
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) -> Single<T> {
        Single.create { single in
            guard let urlRequest = endpoint.toURLRequest() else {
                single(.failure(NetworkError.invalidURL))
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
                guard let result = self?.handleResponse(response, error: error) else { return }
                
                switch result {
                case .success:
                    if let data,
                       let dto = try? JSONDecoder().decode(T.self, from: data) {
                        single(.success(dto))
                    } else {
                        single(.failure(NetworkError.decodingFailed))
                    }
                    
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
    
    private func handleResponse(_ response: URLResponse?, error: Error?) -> Result<HTTPURLResponse, NetworkError> {
        if let error {
            return .failure(.underlying(error))
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(NetworkError.invalidResponseType)
        }
        
        switch httpResponse.statusCode {
        case 200 ..< 300:   
            return .success(httpResponse)
            
        case let statusCode:
            return .failure(NetworkError.statusCode(statusCode))
        }
    }
}

// TODO: 아래 함수들 제거
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
}
