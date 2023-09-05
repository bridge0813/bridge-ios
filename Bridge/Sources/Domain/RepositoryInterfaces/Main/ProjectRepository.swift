//
//  ProjectRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import RxSwift

protocol ProjectRepository {
    func fetchAllProjects() -> Observable<[Project]>
    func fetchHotProjects() -> Observable<[HotProject]>
}
