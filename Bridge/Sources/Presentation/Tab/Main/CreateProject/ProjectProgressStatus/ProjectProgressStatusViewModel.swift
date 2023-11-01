//
//  ProjectProgressStatusViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift
import RxCocoa

final class ProjectProgressStatusViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let progressMethodButtonTapped: Observable<String>
        let progressStep: Observable<String>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let progressMethod: Driver<String>
        let progressStep: Driver<String>
        let isNextButtonEnabled: Driver<Bool>
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
        
        let progressMethod = input.progressMethodButtonTapped
            .do(onNext: { [weak self] method in
                self?.dataStorage.updateProgressMethod(with: method)
            })
            .asDriver(onErrorJustReturn: "")
        
        let progressStep = input.progressStep
            .do(onNext: { [weak self] step in
                self?.dataStorage.updateProgressStep(with: step)
            })
            .asDriver(onErrorJustReturn: "")
                
        let isNextButtonEnabled = Observable.combineLatest(
            input.progressMethodButtonTapped.map { !$0.isEmpty },
            input.progressStep.map { !$0.isEmpty }
        )
        .map { progressMethodIsValid, progressStepIsValid in
            return progressMethodIsValid && progressStepIsValid
        }
        .asDriver(onErrorJustReturn: false)
                
        return Output(
            progressMethod: progressMethod,
            progressStep: progressStep,
            isNextButtonEnabled: isNextButtonEnabled
        )
    }
}
