//
//  FetchRecentSearchUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2/6/24.
//

import RxSwift

/// 최근 검색어 조회
protocol FetchRecentSearchUseCase {
    func fetch() -> Observable<[RecentSearch]>
}

final class DefaultFetchRecentSearchUseCase: FetchRecentSearchUseCase {
    
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func fetch() -> Observable<[RecentSearch]> {
        searchRepository.fetchRecentSearch()
    }
}
