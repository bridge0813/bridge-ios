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
        let allProjects = observeProjectsUseCase.execute().share()  // Observable<[Project]>
        
        /// scrapCount를 비교하여, 인기 섹션에 들어갈 데이터를 가공.
        let hotProjects = allProjects.map { allProjects in
            return allProjects.sorted(by: { $0.scrapCount > $1.scrapCount })
                .prefix(5)
                .map { project in
                    var hotProject = project
                    hotProject.id = project.id + "_hot"
                    
                    return hotProject
                }
        }
        .asDriver(onErrorJustReturn: [Project.onError])
        
        let mainProjects = allProjects.asDriver(onErrorJustReturn: [Project.onError])
        
        return Output(hotProjects: hotProjects, mainProjects: mainProjects)
    }
}

// MARK: - Coordinator
extension MainViewModel {
    
}
