//
//  ProjectRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import RxSwift

protocol ProjectRepository {
    // MARK: - List
    func fetchAllProjects() -> Observable<[ProjectPreview]>
    func fetchProjectsByField(for field: String) -> Observable<[ProjectPreview]>
    func fetchHotProjects() -> Observable<[ProjectPreview]>
    
    // MARK: - Detail
    func fetchProjectDetail(with projectID: Int) -> Observable<Project>
    
    // MARK: - Create
    func create(with project: Project) -> Observable<Int>
}
