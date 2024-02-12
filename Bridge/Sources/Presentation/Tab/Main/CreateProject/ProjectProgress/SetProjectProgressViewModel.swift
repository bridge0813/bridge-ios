//
//  SetProjectProgressViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift
import RxCocoa

final class SetProjectProgressViewModel: ViewModelType {
    // MARK: - Input & Output
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
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    private let dataStorage: ProjectDataStorage
    
    // MARK: - Init
    init(
        coordinator: CreateProjectCoordinator,
        dataStorage: ProjectDataStorage
    ) {
        self.coordinator = coordinator
        self.dataStorage = dataStorage
    }
    
    // MARK: - Transformation
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
        
        let progressStep = input.progressStep
            .do(onNext: { [weak self] step in
                self?.dataStorage.updateProgressStep(with: step)
            })
                
        let isNextButtonEnabled = Observable.combineLatest(
            input.progressMethodButtonTapped.map { !$0.isEmpty },
            input.progressStep.map { !$0.isEmpty }
        )
        .map { progressMethodIsValid, progressStepIsValid in
            return progressMethodIsValid && progressStepIsValid
        }
        
                
        return Output(
            progressMethod: progressMethod.asDriver(onErrorJustReturn: ""),
            progressStep: progressStep.asDriver(onErrorJustReturn: ""),
            isNextButtonEnabled: isNextButtonEnabled.asDriver(onErrorJustReturn: false)
        )
    }
}
