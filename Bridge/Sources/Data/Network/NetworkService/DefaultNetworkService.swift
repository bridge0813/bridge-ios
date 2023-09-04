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
        Observable.just(DefaultNetworkService.chatRoomDTOs)
    }
    
    func leaveChatRoom(id: String) -> Single<Void> {
        Single.create { single in
            
            if let index = DefaultNetworkService.chatRoomDTOs.firstIndex(where: { $0.id == id }) {
                DefaultNetworkService.chatRoomDTOs.remove(at: index)
                single(.success(()))
            } else {
                single(.failure(NetworkError.unknown))
            }
            
            return Disposables.create()
        }
    }
    
    func requestTestProjectsData() -> Observable<[ProjectDTO]> {
        Observable.just(DefaultNetworkService.projectDTOs)
    }
    
    func requestTestHotProjectsData() -> Observable<[ProjectDTO]> {
        Observable.just(DefaultNetworkService.projectDTOs)
    }
    
}

// MARK: - For test
extension DefaultNetworkService {
    static var chatRoomDTOs = [
        ChatRoomDTO(
            id: "1",
            profileImage: nil,
            name: "정호윤",
            time: Date(),
            messageType: .text,
            messagePreview: "메시지 미리보기 1"
        ),
        ChatRoomDTO(
            id: "2",
            profileImage: nil,
            name: "엄지호",
            time: Date(),
            messageType: .text,
            messagePreview: "메시지 미리보기 2"
        ),
        ChatRoomDTO(
            id: "3",
            profileImage: nil,
            name: "홍길동",
            time: Date(),
            messageType: .text,
            messagePreview: "메시지 미리보기 3"
        ),
        ChatRoomDTO(
            id: "4",
            profileImage: nil,
            name: "홍길동",
            time: Date(),
            messageType: .text,
            messagePreview: "메시지 미리보기 4"
        )
    ]
    
    static var projectDTOs = [
        ProjectDTO(
            id: "1",
            title: "모임 플랫폼 디자이너 구합니다",
            numberOfRecruits: 1,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date()
        ),
        ProjectDTO(
            id: "2",
            title: "웹 사이트 디자이너 구해요!!",
            numberOfRecruits: 1,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date()
        ),
        ProjectDTO(
            id: "3",
            title: "개발자, 디자이너 구합니다",
            numberOfRecruits: 6,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date()
        ),
        ProjectDTO(
            id: "4",
            title: "iOS 개발자 구합니다",
            numberOfRecruits: 4,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date()
        ),
        ProjectDTO(
            id: "5",
            title: "모임 플랫폼 디자이너 구합니다",
            numberOfRecruits: 1,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date()
        ),
        ProjectDTO(
            id: "6",
            title: "백엔드 개발자 구합니다",
            numberOfRecruits: 1,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: Date(),
            endDate: Date(),
            deadlineDate: Date()
        )
    ]
}
