//
//  CompletionViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift

final class CompletionViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    
    // MARK: - Init
    init(
        coordinator: CreateProjectCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        input.completeButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showAlert(configuration: .checkProject, cancelAction: {
                    owner.coordinator?.finish()
                })
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
