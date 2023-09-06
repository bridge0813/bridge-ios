//
//  MainViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/30.
//

import RxCocoa
import RxSwift

final class MainViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        var viewDidLoadTrigger: Observable<Void>  // 로그인 여부에 따라, 유저의 분야에 맞게 받아올 정보가 다름(수정 필요)
    }
    
    struct Output {
        var hotProjects: Driver<[Project]>
        var projects: Driver<[Project]>
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
        
        input.viewDidLoadTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchHotProjectsUseCase.execute()
            }
            .bind(to: hotProjects)
            .disposed(by: disposeBag)
        
        input.viewDidLoadTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchProjectsUseCase.execute()
            }
            .bind(to: projects)
            .disposed(by: disposeBag)
        
        return Output(
            hotProjects: hotProjects.asDriver(onErrorJustReturn: [Project.onError]),
            projects: projects.asDriver(onErrorJustReturn: [Project.onError])
        )
    }

}

// MARK: - Coordinator

// MARK: - Data Section
extension MainViewModel {
    enum Section: CaseIterable {
        case hot
        case main
    }
}
