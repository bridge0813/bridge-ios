//
//  FetchProjectsByFieldUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/26.
//

import RxSwift

protocol FetchProjectsByFieldUseCase {
    func fetchProjects(for field: String) -> Observable<[ProjectPreview]>
}

final class DefaultFetchProjectsByFieldUseCase: FetchProjectsByFieldUseCase {
    private let projectRepository: ProjectRepository
    
    init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }
    
    func fetchProjects(for field: String) -> Observable<[ProjectPreview]> {
        projectRepository.fetchProjectsByField(for: field)
    }
}
