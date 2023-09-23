//
//  ProjectDescriptionInputViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift

final class ProjectDescriptionInputViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let nextButtonTapped: Observable<Void>
        let titleTextChanged: Observable<String>
        let descriptionTextChanged: Observable<String>
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    private let dataStore: ProjectDataStore
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator,
        dataStore: ProjectDataStore
    ) {
        self.coordinator = coordinator
        self.dataStore = dataStore
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                // 네트워킹 로직 구현...
                owner.coordinator?.showCompletionViewController()
            })
            .disposed(by: disposeBag)
        
        input.titleTextChanged
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.dataStore.updateTitle(with: text)
            })
            .disposed(by: disposeBag)
        
        input.descriptionTextChanged
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.dataStore.updateDescription(with: text)
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
