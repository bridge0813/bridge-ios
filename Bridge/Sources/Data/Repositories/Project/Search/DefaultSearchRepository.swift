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
        let recentSearchEndpoint = SearchEndpoint.fetchRecentSearch
        
        return networkService.request(to: recentSearchEndpoint, interceptor: AuthInterceptor())
            .decode(type: [RecentSearchResponseDTO].self, decoder: JSONDecoder())
            .map { recentSearchDTOs in
                return recentSearchDTOs.map { $0.toEntity() }
            }
    }
    
    func removeAllSearch() -> Observable<Void> {
        let removeAllSearchEndpoint = SearchEndpoint.removeAllSearch
        
        return networkService.request(to: removeAllSearchEndpoint, interceptor: AuthInterceptor())
            .map { _ in }
    }
    
    func searchProjects(by query: String) -> Observable<[ProjectPreview]> {
        let searchProjectDTO = SearchProjectRequestDTO(searchWord: query)
        let searchProjectEndpoint = SearchEndpoint.searchProjects(requestDTO: searchProjectDTO)
        
        return networkService.request(to: searchProjectEndpoint, interceptor: nil)
            .decode(type: [ProjectPreviewResponseDTO].self, decoder: JSONDecoder())
            .map { projectPreviewDTOs in
                projectPreviewDTOs.map { $0.toEntity() }
            }
    }
}
