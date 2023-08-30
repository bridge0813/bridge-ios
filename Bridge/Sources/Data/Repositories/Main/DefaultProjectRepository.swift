//
//  DefaultProjectRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation
import RxSwift

final class DefaultProjectRepository: ProjectRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func observeProjects() -> Observable<[Project]> {
        networkService
            .requestTestProjectsData()
            .map { data -> [Project] in data.compactMap { $0.toModel() } }
    }
}
