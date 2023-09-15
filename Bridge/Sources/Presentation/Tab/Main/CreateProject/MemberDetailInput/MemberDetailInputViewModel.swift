//
//  MemberDetailInputViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift

final class MemberDetailInputViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    private var selectedFields: [String]
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator,
        selectedFields: [String]
    ) {
        self.coordinator = coordinator
        self.selectedFields = selectedFields
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showApplicantRestrictionViewController()
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
