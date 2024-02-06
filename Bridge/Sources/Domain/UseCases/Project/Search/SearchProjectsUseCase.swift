//
//  FetchSearchedProjectsUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2/7/24.
//

import RxSwift

protocol SearchProjectsUseCase {
    func search(by query: String) -> Observable<[ProjectPreview]>
}

final class DefaultSearchProjectsUseCase: SearchProjectsUseCase {
    
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func search(by query: String) -> Observable<[ProjectPreview]> {
        searchRepository.searchProjects(by: query)
    }
}
