//
//  MockProjectDetailRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/13.
//

import RxSwift

final class MockProjectDetailRepository: ProjectDetailRepository {
    func fetchProject(with projectID: Int) -> Observable<ProjectDetail> {
        .just(ProjectDetailDTO.projectDetailTest.toEntity())
    }
}
