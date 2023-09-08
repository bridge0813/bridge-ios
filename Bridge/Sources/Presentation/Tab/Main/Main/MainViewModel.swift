//
//  MainViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import Foundation
import RxCocoa
import RxSwift

final class MainViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let viewWillAppear: Observable<Bool>  // 로그인 여부에 따라, 유저의 분야에 맞게 받아올 정보가 다름(수정 필요)
        let didScroll: Observable<CGPoint>
        let notificationButtonTapped: Observable<Void>
        let filterButtonTapped: Observable<Void>
        let searchButtonTapped: Observable<String?>
        let itemSelected: Observable<IndexPath>
        let createButtonTapped: Observable<Void>
    }
    
    struct Output {
        let hotProjects: Driver<[Project]>
        let projects: Driver<[Project]>
        let layoutMode: Driver<CreateButtonDisplayState>
    }

    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    private let fetchProjectsUseCase: FetchAllProjectsUseCase
    private let fetchHotProjectsUseCase: FetchHotProjectsUseCase
    
    // MARK: - Initializer
    init(
        coordinator: MainCoordinator,
        fetchProjectsUseCase: FetchAllProjectsUseCase,
        fetchHotProjectsUseCase: FetchHotProjectsUseCase
    ) {
        self.coordinator = coordinator
        self.fetchProjectsUseCase = fetchProjectsUseCase
        self.fetchHotProjectsUseCase = fetchHotProjectsUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let hotProjects = bindHotProjects(from: input)
        let projects = bindMainProjects(from: input)
        let layoutMode = bindButtonDisplayState(from: input)
        
        bindNotifButtonDidTap(from: input)
        bindFilterButtonDidTap(from: input)
        bindSearchButtonDidTap(from: input)
        bindCreateButtonDidTap(from: input)
        bindItemSelected(from: input, hotProjects: hotProjects.value, mainProjects: projects.value)
        
        return Output(
            hotProjects: hotProjects.asDriver(onErrorJustReturn: [Project.onError]),
            projects: projects.asDriver(onErrorJustReturn: [Project.onError]),
            layoutMode: layoutMode.asDriver(onErrorJustReturn: .both)
        )
    }
}

// MARK: - Coordinator
extension MainViewModel {
    private func showProjectDetail(
        from indexPath: IndexPath,
        hotProjects: [Project],
        mainProjects: [Project]
    ) {
        let section = Section.allCases[indexPath.section]
        
        switch section {
        case .hot:
            let project = hotProjects[indexPath.row]
            coordinator?.connectToProjectDetailFlow(with: project)
            
        case .main:
            let project = mainProjects[indexPath.row]
            coordinator?.connectToProjectDetailFlow(with: project)
        }
    }
}

// MARK: - UI DataSource
extension MainViewModel {
    enum Section: CaseIterable {
        case hot
        case main
    }
    
    enum CreateButtonDisplayState {
        case both
        case only
    }
}

// MARK: - Binding
extension MainViewModel {
    private func bindHotProjects(from input: Input) -> BehaviorRelay<[Project]> {
        let hotProjects = BehaviorRelay<[Project]>(value: [])
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchHotProjectsUseCase.execute()
            }
            .bind(to: hotProjects)
            .disposed(by: disposeBag)
        
        return hotProjects
    }
    
    private func bindMainProjects(from input: Input) -> BehaviorRelay<[Project]> {
        let projects = BehaviorRelay<[Project]>(value: [])
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchProjectsUseCase.execute()
            }
            .bind(to: projects)
            .disposed(by: disposeBag)
        
        return projects
    }
    
    private func bindButtonDisplayState(from input: Input) -> Observable<CreateButtonDisplayState> {
        return input.didScroll
            .map { $0.y <= 0 ? CreateButtonDisplayState.both : .only }
            .distinctUntilChanged()
    }
    
    private func bindNotifButtonDidTap(from input: Input) {
        input.notificationButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.connectToNotificationFlow()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindFilterButtonDidTap(from input: Input) {
        input.filterButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.connectToProjectFilteringFlow()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSearchButtonDidTap(from input: Input) {
        input.searchButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                guard let text else { return }
                owner.coordinator?.connectToProjectSearchFlow(with: text)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCreateButtonDidTap(from input: Input) {
        input.createButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.connectToCreateProjectFlow()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindItemSelected(from input: Input, hotProjects: [Project], mainProjects: [Project]) {
        input.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                owner.showProjectDetail(
                    from: indexPath,
                    hotProjects: hotProjects,
                    mainProjects: mainProjects
                )
            })
            .disposed(by: disposeBag)
    }
}
