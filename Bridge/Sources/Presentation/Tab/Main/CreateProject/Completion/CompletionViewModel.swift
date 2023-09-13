//
//  CompletionViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift

final class CompletionViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let completionButtonTapped: Observable<Void>
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.completionButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                print("completion")
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
