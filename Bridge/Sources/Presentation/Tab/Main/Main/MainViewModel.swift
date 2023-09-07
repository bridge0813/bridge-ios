//
//  MainViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import CoreFoundation
import CoreGraphics
import RxCocoa
import RxSwift

final class MainViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let viewDidLoad: Observable<Void>  // 로그인 여부에 따라, 유저의 분야에 맞게 받아올 정보가 다름(수정 필요)
        let didScroll: Observable<CGPoint>
        
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
        let hotProjects = BehaviorRelay<[Project]>(value: [])
        let projects = BehaviorRelay<[Project]>(value: [])
        
        input.viewDidLoad
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchHotProjectsUseCase.execute()
            }
            .bind(to: hotProjects)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchProjectsUseCase.execute()
            }
            .bind(to: projects)
            .disposed(by: disposeBag)
        
        let layoutMode = input.didScroll
            .map { $0.y <= 0 ? CreateButtonDisplayState.both : .only }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .both)
        
        return Output(
            hotProjects: hotProjects.asDriver(onErrorJustReturn: [Project.onError]),
            projects: projects.asDriver(onErrorJustReturn: [Project.onError]),
            layoutMode: layoutMode
        )
    }

}

// MARK: - Coordinator

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
