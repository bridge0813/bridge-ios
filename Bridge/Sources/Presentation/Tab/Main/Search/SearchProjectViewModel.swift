//
//  SearchProjectViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2/5/24.
//

import Foundation
import RxCocoa
import RxSwift

final class SearchProjectViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let textFieldEditingDidBegin: Observable<Void>
        let searchButtonTapped: Observable<String>
        let cancelButtonTapped: ControlEvent<Void>
        let recentSearchSelected: Observable<RecentSearch>
        let removeAllButtonTapped: Observable<Void>
    }
    
    struct Output {
        let projects: Driver<[ProjectPreview]>
        let recentSearches: Observable<[RecentSearch]>
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    
    private let fetchRecentSearchUseCase: FetchRecentSearchUseCase
    private let searchProjectsUseCase: SearchProjectsUseCase
    
    // MARK: - Init
    init(
        coordinator: MainCoordinator,
        fetchRecentSearchUseCase: FetchRecentSearchUseCase,
        searchProjectsUseCase: SearchProjectsUseCase
    ) {
        self.coordinator = coordinator
        self.fetchRecentSearchUseCase = fetchRecentSearchUseCase
        self.searchProjectsUseCase = searchProjectsUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let projectListRelay = BehaviorRelay<[ProjectPreview]>(value: [])
        let recentSearchesRelay = BehaviorRelay<[RecentSearch]>(value: [])
        
        input.textFieldEditingDidBegin
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.fetchRecentSearchUseCase.fetch().toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let recentSearches):
                    recentSearchesRelay.accept(recentSearches)
                    
                case .failure(let error):
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "최근 검색어 조회에 실패했습니다.",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        // 검색
        input.searchButtonTapped
            .withUnretained(self)
            .flatMapLatest { owner, query in
                owner.searchProjectsUseCase.search(by: query).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let projects):
                    projectListRelay.accept(projects)
                    
                case .failure(let error):
                    projectListRelay.accept([])
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "검색에 실패했습니다.",
                        description: error.localizedDescription
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        input.cancelButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.pop()
            })
            .disposed(by: disposeBag)
        
        return Output(
            projects: projectListRelay.asDriver(),
            recentSearches: recentSearchesRelay.asObservable()
        )
    }
}
