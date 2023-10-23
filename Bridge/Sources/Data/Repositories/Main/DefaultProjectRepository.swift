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
        .just(ProjectDTO.projectTestArray.compactMap { $0.toModel() })
    }
    
    func fetchHotProjects() -> Observable<[Project]> {
        .just(ProjectDTO.projectTestArray.compactMap { $0.toModel() })
    }
}
