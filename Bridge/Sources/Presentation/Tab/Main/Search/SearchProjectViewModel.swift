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
    }
    
    struct Output {
        let projects: Driver<[ProjectPreview]>
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MainCoordinator?
    
    private let fetchRecentSearchUseCase: FetchRecentSearchUseCase
    
    // MARK: - Init
    init(
        coordinator: MainCoordinator,
        fetchRecentSearchUseCase: FetchRecentSearchUseCase
    ) {
        self.coordinator = coordinator
        self.fetchRecentSearchUseCase = fetchRecentSearchUseCase
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
        
        input.searchButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                print("검색 시작 \(text)")
            })
            .disposed(by: disposeBag)
        
        input.cancelButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.pop()
            })
            .disposed(by: disposeBag)
        
        return Output(
            projects: projectListRelay.asDriver()
        )
    }
}
