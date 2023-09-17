//
//  ProjectProgressStatusViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift

final class ProjectProgressStatusViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    private var project: Project
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator,
        project: Project
    ) {
        self.coordinator = coordinator
        self.project = project
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showProjectDescriptionInputViewController()
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
