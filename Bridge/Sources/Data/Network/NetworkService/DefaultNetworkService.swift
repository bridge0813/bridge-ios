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
        let testFields = [
            RecruitmentField.developer(.iOS(2)),
            RecruitmentField.designer(.uiux(2)),
            RecruitmentField.developer(.backend(2))
        ]
        
        let currentDate = Date()
        let testEndDate = Calendar.current.date(byAdding: .day, value: 20, to: currentDate) ?? Date()
        
        let projectDTO = ProjectDTO(
            id: "1",
            title: "웹 사이트 개발자 구합니다",
            fields: testFields,
            requiredFieldTag: ["디자이너"],
            requiredStackTag: ["UI/UX"],
            startDate: currentDate,
            endDate: testEndDate,
            deadlineDate: testEndDate
        )
        
        return Observable.just([projectDTO])
    }
}
