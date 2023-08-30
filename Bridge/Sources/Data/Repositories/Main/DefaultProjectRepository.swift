//
//  DefaultProjectRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation
import RxSwift

final class DefaultProjectRepository: ProjectRepository {
    // MARK: - Properties
    private let networkService: NetworkService
    
    // MARK: - Initializer
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // MARK: - Methods
    func observeProjects() -> Observable<[Project]> {
        networkService
            .requestTestProjectsData()
            .map { data -> [Project] in data.compactMap { $0.toModel() } }
    }
}
