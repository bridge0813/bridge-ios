//
//  ApplicantRestrictionViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/14.
//

import RxSwift

final class ApplicantRestrictionViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let nextButtonTapped: Observable<Void>
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
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showProjectDatePickerViewController()
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
