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
        var projects: Driver<[Project]>
    }

    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    private let observeProjectsUseCase: ObserveProjectsUseCase
    
    // MARK: - Initializer
    init(
        coordinator: MainCoordinator,
        observeProjectsUseCase: ObserveProjectsUseCase
    ) {
        self.coordinator = coordinator
        self.observeProjectsUseCase = observeProjectsUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let projects = observeProjectsUseCase.execute().share()
        projects.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        return Output(projects: projects.asDriver(onErrorJustReturn: [Project.onError]))
    }
}

// MARK: - Coordinator
extension MainViewModel {
    
}
