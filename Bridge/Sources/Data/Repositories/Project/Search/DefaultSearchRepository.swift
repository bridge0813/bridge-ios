//
//  DefaultSearchRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2/6/24.
//

import Foundation
import RxSwift

final class DefaultSearchRepository: SearchRepository {
    
    private let networkService: NetworkService
    private let tokenStorage: TokenStorage
    
    init(networkService: NetworkService, tokenStorage: TokenStorage = KeychainTokenStorage()) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
    
    // 최근 검색어 조회
    func fetchRecentSearch() -> Observable<[RecentSearch]> {
        let endpoint = SearchEndpoint.fetchRecentSearch
        
        return networkService.request(to: endpoint, interceptor: AuthInterceptor())
            .decode(type: [RecentSearchResponseDTO].self, decoder: JSONDecoder())
            .map { recentSearchDTOs in
                return recentSearchDTOs.map { $0.toEntity() }
            }
    }
}
