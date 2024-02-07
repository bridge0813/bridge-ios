//
//  RemoveSearchUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2/7/24.
//

import RxSwift

protocol RemoveSearchUseCase {
    func removeAll() -> Observable<Void>
}

final class DefaultRemoveSearchUseCase: RemoveSearchUseCase {
    
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func removeAll() -> Observable<Void> {
        searchRepository.removeAllSearch()
    }
}
