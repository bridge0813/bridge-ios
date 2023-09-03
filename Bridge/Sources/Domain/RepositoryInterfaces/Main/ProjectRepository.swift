//
//  ProjectRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import RxSwift

protocol ProjectRepository {
    func observeProjects() -> Observable<[Project]>
    func fetchHotProjects() -> Observable<[HotProject]>
}
