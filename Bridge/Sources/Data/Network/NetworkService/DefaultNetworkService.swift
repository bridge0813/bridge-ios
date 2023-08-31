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
    func requestTestChatRoom(id: String) -> Observable<ChatRoomDTO> {
        switch id {
        case "1":
            return Observable.just(
                ChatRoomDTO(
                    id: "1",
                    profileImage: nil,
                    name: "정호윤",
                    time: Date(),
                    messageType: .text,
                    messagePreview: "메시지 미리보기 1"
                )
            )
            
        case "2":
            return Observable.just(
                ChatRoomDTO(
                    id: "2",
                    profileImage: nil,
                    name: "엄지호",
                    time: Date(),
                    messageType: .text,
                    messagePreview: "메시지 미리보기 2"
                )
            )
            
        case "3":
            return Observable.just(
                ChatRoomDTO(
                    id: "3",
                    profileImage: nil,
                    name: "홍길동",
                    time: Date(),
                    messageType: .text,
                    messagePreview: "메시지 미리보기 3"
                )
            )
            
        default:
            return Observable.just(
                ChatRoomDTO(
                    id: "-1",
                    profileImage: nil,
                    name: "기타",
                    time: Date(),
                    messageType: .text,
                    messagePreview: "기타"
                )
            )
        }
    }
    
    func requestTestChatRooms() -> Observable<[ChatRoomDTO]> {
        Observable.just([
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
        ])
    }
    
    func requestTestProjectsData() -> Observable<[ProjectDTO]> {
        let currentDate = Date()
        
        let projectDTO = ProjectDTO(
            id: "1",
            title: "개발자, 디자이너 구합니다",
            numberOfRecruits: 6,
            recruitmentField: ["개발자", "디자이너"],
            techStackTags: ["iOS", "BackEnd", "UI/UX"],
            startDate: currentDate,
            endDate: currentDate,
            deadlineDate: currentDate
        )
        
        return Observable.just([projectDTO])
    }
}
