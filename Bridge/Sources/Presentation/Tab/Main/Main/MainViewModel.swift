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
        var hotProjects: Driver<[Project]>
        var mainProjects: Driver<[Project]>
    }

    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    private let fetchProjectsUseCase: FetchProjectsUseCase
    
    // MARK: - Initializer
    init(
        coordinator: MainCoordinator,
        fetchProjectsUseCase: FetchProjectsUseCase
    ) {
        self.coordinator = coordinator
        self.fetchProjectsUseCase = fetchProjectsUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let allProjects = fetchProjectsUseCase.execute().share()  // Observable<[Project]>
        let mainProjects = allProjects.asDriver(onErrorJustReturn: [Project.onError])
        
        return Output(hotProjects: hotProjects, mainProjects: mainProjects)
    }
}

// MARK: - Coordinator
extension MainViewModel {
    
}
