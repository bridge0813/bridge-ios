//
//  MockUserRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/12/04.
//  Edited by 정호윤 on 2023/12/12.

import RxSwift

final class MockUserRepository: UserRepository {

    func fetchProfilePreview() -> Observable<ProfilePreview> {
        .just(ProfilePreviewResponseDTO.testData.toEntity())
//        .error(NetworkError.statusCode(401))
    }
    
    func changeField(selectedFields: [String]) -> Observable<Void> {
        .just(())
    }
    
    func fetchBookmarkedProjects() -> Observable<[BookmarkedProject]> {
        .just(BookmarkedProjectResponseDTO.testData.map { $0.toEntity() })
    }
}
