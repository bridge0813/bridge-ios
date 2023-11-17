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
        .just(ProjectDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchHotProjects() -> Observable<[Project]> {
        .just(ProjectDTO.projectTestArray.compactMap { $0.toEntity() })
    }
    
    func fetchProjectDetail(with projectID: Int) -> Observable<ProjectDetail> {
        .just(ProjectDetailDTO.projectDetailTest.toEntity())
    }
}
