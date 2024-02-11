//
//  ProjectRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import RxSwift

protocol ProjectRepository {
    // 모든 모집글 조회
    func fetchAllProjects() -> Observable<[ProjectPreview]>
    
    // 분야에 맞는 모집글 조회
    func fetchProjectsByField(for field: String) -> Observable<[ProjectPreview]>
    
    // 인기 모집글 조회
    func fetchHotProjects() -> Observable<[ProjectPreview]>
    
    // 마감임박 모집글 조회
    func fetchDeadlineProjects() -> Observable<[ProjectPreview]>
    
    // 모집글 상세 조회
    func fetchProjectDetail(with projectID: Int) -> Observable<Project>
    
    // 내가 지원한 모집글 조회
    func fetchAppliedProjects() -> Observable<[ProjectPreview]>
    
    // 내가 작성한 모집글 조회
    func fetchMyProjects() -> Observable<[ProjectPreview]>
    
    // 필터링된 모집글 조회
    func fetchFilteredProjects(filterBy fieldTechStack: FieldTechStack) -> Observable<[ProjectPreview]>
    
    // 모집글 작성
    func create(project: Project) -> Observable<Int>
    
    // 모집글 수정
    func update(project: Project) -> Observable<Void>
    
    // 북마크
    func bookmark(projectID: Int) -> Observable<Int>
    
    // 모집글 제거
    func delete(projectID: Int) -> Observable<Int>
    
    // 모집글 마감
    func close(projectID: Int) -> Observable<Int>
}
