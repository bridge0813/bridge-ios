//
//  SearchRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2/6/24.
//

import RxSwift

protocol SearchRepository {
    /// 최근 검색어 조회
    func fetchRecentSearch() -> Observable<[RecentSearch]>
    
}
