//
//  DefaultProjectRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import RxSwift

final class DefaultProjectRepository: ProjectRepository {
    // MARK: - Properties
    private let networkService: NetworkService
    
    // MARK: - Initializer
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // MARK: - Methods
    func fetchAllProjects() -> Observable<[Project]> {
        networkService
            .requestTestProjectsData()
            .map { data -> [Project] in data.compactMap { $0.toModel() } }
    }
    
    func fetchHotProjects() -> Observable<[HotProject]> {
        networkService
            .requestTestHotProjectsData()
            .map { data -> [HotProject] in
                data.compactMap { $0.toModel() }
            }
    }
    
}
