//
//  DefaultProjectDetailRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/13.
//

import RxSwift

final class DefaultProjectDetailRepository: ProjectDetailRepository {
    // MARK: - Properties
    private let networkService: NetworkService
    
    // MARK: - Initializer
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // MARK: - Methods
    func fetchProject(with projectID: Int) -> Observable<ProjectDetail> {
        .just(ProjectDetailDTO.projectDetailTest.toEntity())
    }
}
