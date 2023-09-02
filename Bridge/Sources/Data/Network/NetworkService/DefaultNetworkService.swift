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
    
    func requestTestData() -> Observable<[ChatRoomDTO]> {
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
            )
        ])
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
                scrapCount: 10
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
                scrapCount: 9
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
                scrapCount: 8
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
                scrapCount: 7
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
                scrapCount: 6
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
                scrapCount: 5
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
                scrapCount: 4
            )
        ])
    }
}
