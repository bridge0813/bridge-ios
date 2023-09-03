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
        
        /// scrapCount를 비교하여, 인기 섹션에 들어갈 데이터를 가공.
        /// id에 "hot"을 추가하는 과정은 mainProjects와 겹치는 id가 없기 위해서.
        let hotProjects = allProjects.map { allProjects in
            return allProjects.sorted(by: { $0.favorites > $1.favorites })
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
