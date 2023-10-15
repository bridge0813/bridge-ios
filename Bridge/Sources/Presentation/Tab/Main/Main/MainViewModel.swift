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
        let filterButtonTapped: Observable<Void>
        let itemSelected: Observable<IndexPath>
        let createButtonTapped: Observable<Void>
    }
    
    struct Output {
        let hotProjects: Driver<[Project]>
        let projects: Driver<[Project]>
        let buttonDisplayMode: Driver<CreateButtonDisplayState>
        let headerAlpha: Driver<CGFloat>
        let collectionViewTopMargin: Driver<CGFloat>
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
        let hotProjects = BehaviorRelay<[Project]>(value: [])
        let projects = BehaviorRelay<[Project]>(value: [])
        
        // MARK: - Fetch Projects
        input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Observable<[Project]> in
                return owner.fetchHotProjectsUseCase.execute()
            }
            .distinctUntilChanged()
            .bind(to: hotProjects)
            .disposed(by: disposeBag)

        input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Observable<[Project]> in
                return owner.fetchProjectsUseCase.execute()
            }
            .distinctUntilChanged()
            .bind(to: projects)
            .disposed(by: disposeBag)
        
        // MARK: - Item Selected
        input.itemSelected
            .withUnretained(self)
            .map { owner, indexPath in
                owner.findProjectByIndex(indexPath, hotProjects: hotProjects.value, projects: projects.value)
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, project in
                owner.coordinator?.connectToProjectDetailFlow(with: project.id)
            })
            .disposed(by: disposeBag)
        
        // MARK: - Button State
        let layoutMode = input.didScroll
            .map { $0.y <= 0 ? CreateButtonDisplayState.both : .only }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
        
        let headerAlpha = input.didScroll
            .map { offset in
                
                let headerHeight: CGFloat = 102.0
                
                // 알파 값의 최소 및 최대 범위 설정
                let minAlpha: CGFloat = 0.0
                let maxAlpha: CGFloat = 1.0
                let alpha = max(minAlpha, maxAlpha - (offset.y / headerHeight))
                
                return alpha
            }
            .observe(on: MainScheduler.asyncInstance)
        
        let collectionViewTopMargin = input.didScroll
            .map { offset in
                let headerHeight: CGFloat = 102.0
                
                let maxTop: CGFloat = 150.0
                let minTop: CGFloat = 48.0
                let topMargin = min(maxTop, max(minTop, maxTop - (offset.y * (maxTop - minTop) / headerHeight)))
                
                return topMargin
            }
            .observe(on: MainScheduler.asyncInstance)
        
        // MARK: - Button Actions
        input.filterButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.connectToProjectFilteringFlow()
            })
            .disposed(by: disposeBag)
        
        input.createButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.connectToCreateProjectFlow()
            })
            .disposed(by: disposeBag)
        
        return Output(
            hotProjects: hotProjects.asDriver(onErrorJustReturn: [Project.onError]),
            projects: projects.asDriver(onErrorJustReturn: [Project.onError]),
            buttonDisplayMode: layoutMode.asDriver(onErrorJustReturn: .both),
            headerAlpha: headerAlpha.asDriver(onErrorJustReturn: 1),
            collectionViewTopMargin: collectionViewTopMargin.asDriver(onErrorJustReturn: 150)
        )
    }
}

// MARK: - Coordinator
extension MainViewModel {
    
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

// MARK: - UtilityMethods
extension MainViewModel {
    private func findProjectByIndex(
        _ indexPath: IndexPath,
        hotProjects: [Project],
        projects: [Project]
    ) -> Project {
        let section = Section.allCases[indexPath.section]
    
        switch section {
        case .hot:
            return hotProjects[indexPath.row]
            
        case .main:
            return projects[indexPath.row]
        }
    }
}
