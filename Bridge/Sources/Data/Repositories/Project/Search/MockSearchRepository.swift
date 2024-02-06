//
//  MockSearchRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2/6/24.
//

import RxSwift

final class MockSearchRepository: SearchRepository {
    func fetchRecentSearch() -> Observable<[RecentSearch]> {
        .just(RecentSearchResponseDTO.testArray.map { $0.toEntity() })
    }
    
    func searchProjects(by query: String) -> Observable<[ProjectPreview]> {
        .just(ProjectPreviewResponseDTO.projectTestArray.compactMap { $0.toEntity() })
    }
}
