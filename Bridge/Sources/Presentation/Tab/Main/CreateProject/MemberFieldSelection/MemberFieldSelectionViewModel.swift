//
//  MemberFieldSelectionViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift

final class MemberFieldSelectionViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let nextButtonTapped: Observable<Void>
        let dismissButtonTapped: Observable<Void>
        
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
                owner.coordinator?.showMemberDetailInputViewController()
            })
            .disposed(by: disposeBag)
        
        input.dismissButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.finish()
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
