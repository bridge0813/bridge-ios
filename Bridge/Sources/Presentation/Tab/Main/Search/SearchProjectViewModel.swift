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
    
    // MARK: - Init
    init(
        coordinator: MainCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let projectListRelay = BehaviorRelay<[ProjectPreview]>(value: [])
        let recentSearchesRelay = BehaviorRelay<[String]>(value: [])
        
        input.textFieldEditingDidBegin
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                print("최근 검색어 가져오기")
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
