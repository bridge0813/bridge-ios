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
    func fetchProjectDetail(with projectID: Int) -> Observable<(Project, SignInNeeded)>
    
    func fetchAppliedProjects() -> Observable<[ProjectPreview]>
    func fetchMyProjects() -> Observable<[ProjectPreview]>
    
    // MARK: - Create
    func create(project: Project) -> Observable<Int>
    
    // MARK: - Bookmark
    func bookmark(projectID: Int) -> Observable<Int>
    
    // MARK: - Delete
    func delete(projectID: Int) -> Observable<Int>
    
    // MARK: - CancelApplication
    func cancel(projectID: Int) -> Observable<Int>
    
    // MARK: - Accept
    func accept(projectID: Int, applicantID: Int) -> Observable<Int>
    
    // MARK: - Reject
    func reject(projectID: Int, applicantID: Int) -> Observable<Int>
    
    // MARK: - Apply
    func apply(projectID: Int) -> Observable<Void>
}
