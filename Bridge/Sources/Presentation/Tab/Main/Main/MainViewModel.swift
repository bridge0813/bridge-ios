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
        var viewDidLoadTrigger: PublishRelay<Void>  // 로그인 여부에 따라, 유저의 분야에 맞게 받아올 정보가 다름(수정 필요)
    }
    
    struct Output {
        var hotProjects: Driver<[ProjectItems]>
        var allProjects: Driver<[ProjectItems]>
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
        let hotProjects = BehaviorRelay<[ProjectItems]>(value: [])
        let allProjects = BehaviorRelay<[ProjectItems]>(value: [])
        
        input.viewDidLoadTrigger
            .withUnretained(self)
            .flatMap { _ in
                self.fetchHotProjectsUseCase.execute()
            }
            .map { hotProjects in
                hotProjects.map { ProjectItems.hotProject($0) }
            }
            .bind(to: hotProjects)
            .disposed(by: disposeBag)
        
        input.viewDidLoadTrigger
            .withUnretained(self)
            .flatMap { _ in
                self.fetchProjectsUseCase.execute()
            }
            .map { allProjects in
                allProjects.map { ProjectItems.project($0) }
            }
            .bind(to: allProjects)
            .disposed(by: disposeBag)
        
        return Output(
            hotProjects: hotProjects.asDriver(onErrorJustReturn: [ProjectItems.hotProject(HotProject.onError)]),
            allProjects: allProjects.asDriver(onErrorJustReturn: [ProjectItems.project(Project.onError)])
        )
    }

}

// MARK: - Coordinator
extension MainViewModel {
    
}
