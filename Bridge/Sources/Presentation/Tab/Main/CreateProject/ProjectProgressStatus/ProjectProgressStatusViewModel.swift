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
        let progressMethodButtonTapped: Observable<String>
        let progressStep: Observable<String>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    private let dataStorage: ProjectDataStorage
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator,
        dataStorage: ProjectDataStorage
    ) {
        self.coordinator = coordinator
        self.dataStorage = dataStorage
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.showProjectDescriptionInputViewController()
            })
            .disposed(by: disposeBag)
        
        input.progressMethodButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, method in
                owner.dataStorage.updateProgressMethod(with: method)
            })
            .disposed(by: disposeBag)
        
        input.progressStep
            .withUnretained(self)
            .subscribe(onNext: { owner, step in
                owner.dataStorage.updateProgressStatus(with: step)
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
