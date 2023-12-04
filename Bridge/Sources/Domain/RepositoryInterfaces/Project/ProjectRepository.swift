//
//  ProjectRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import RxSwift

protocol ProjectRepository {
    // MARK: - Fetch
    func fetchAllProjects() -> Observable<[ProjectPreview]>
    func fetchProjectsByField(for field: String) -> Observable<[ProjectPreview]>
    func fetchHotProjects() -> Observable<[ProjectPreview]>
    func fetchDeadlineProjects() -> Observable<[ProjectPreview]>
    func fetchProjectDetail(with projectID: Int) -> Observable<Project>
    
    // MARK: - Create
    func create(project: Project) -> Observable<Int>
    
    // MARK: - Bookmark
    func bookmark(projectID: Int) -> Observable<Int>
}
