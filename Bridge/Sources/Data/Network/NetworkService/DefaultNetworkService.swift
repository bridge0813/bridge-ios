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
        let currentDate = Date()
        
        return Observable.just([
            ProjectDTO(
                id: "1",
                title: "모임 플랫폼 디자이너 구합니다",
                numberOfRecruits: 1,
                recruitmentField: ["개발자", "디자이너"],
                techStackTags: ["iOS", "BackEnd", "UI/UX"],
                startDate: currentDate,
                endDate: currentDate,
                deadlineDate: currentDate,
                favorites: 10
            ),
            ProjectDTO(
                id: "2",
                title: "웹 사이트 디자이너 구해요!!",
                numberOfRecruits: 1,
                recruitmentField: ["개발자", "디자이너"],
                techStackTags: ["iOS", "BackEnd", "UI/UX"],
                startDate: currentDate,
                endDate: currentDate,
                deadlineDate: currentDate,
                favorites: 9
            ),
            ProjectDTO(
                id: "3",
                title: "개발자, 디자이너 구합니다",
                numberOfRecruits: 6,
                recruitmentField: ["개발자", "디자이너"],
                techStackTags: ["iOS", "BackEnd", "UI/UX"],
                startDate: currentDate,
                endDate: currentDate,
                deadlineDate: currentDate,
                favorites: 8
            ),
            ProjectDTO(
                id: "4",
                title: "iOS 개발자 구합니다",
                numberOfRecruits: 4,
                recruitmentField: ["개발자", "디자이너"],
                techStackTags: ["iOS", "BackEnd", "UI/UX"],
                startDate: currentDate,
                endDate: currentDate,
                deadlineDate: currentDate,
                favorites: 7
            ),
            ProjectDTO(
                id: "1",
                title: "모임 플랫폼 디자이너 구합니다",
                numberOfRecruits: 1,
                recruitmentField: ["개발자", "디자이너"],
                techStackTags: ["iOS", "BackEnd", "UI/UX"],
                startDate: currentDate,
                endDate: currentDate,
                deadlineDate: currentDate,
                favorites: 6
            ),
            ProjectDTO(
                id: "2",
                title: "웹 사이트 디자이너 구해요!!",
                numberOfRecruits: 1,
                recruitmentField: ["개발자", "디자이너"],
                techStackTags: ["iOS", "BackEnd", "UI/UX"],
                startDate: currentDate,
                endDate: currentDate,
                deadlineDate: currentDate,
                favorites: 5
            ),
            ProjectDTO(
                id: "3",
                title: "개발자, 디자이너 구합니다",
                numberOfRecruits: 6,
                recruitmentField: ["개발자", "디자이너"],
                techStackTags: ["iOS", "BackEnd", "UI/UX"],
                startDate: currentDate,
                endDate: currentDate,
                deadlineDate: currentDate,
                favorites: 4
            )
        ])
    }
}
