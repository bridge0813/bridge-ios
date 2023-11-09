//
//  ProjectDescriptionInputViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift
import RxCocoa

final class ProjectDescriptionInputViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let titleTextChanged: Observable<String>
        let descriptionTextChanged: Observable<String>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
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
                // 네트워킹 로직 구현...
                owner.coordinator?.showCompletionViewController()
            })
            .disposed(by: disposeBag)
        
        input.titleTextChanged
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.dataStorage.updateTitle(with: text)
            })
            .disposed(by: disposeBag)
        
        input.descriptionTextChanged
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.dataStorage.updateDescription(with: text)
            })
            .disposed(by: disposeBag)
        
        let isNextButtonEnabled = Observable.combineLatest(
            input.titleTextChanged.map { !$0.isEmpty },
            input.descriptionTextChanged.map { !$0.isEmpty }
        )
        .map { titleIsValid, descriptionIsValid in
            return titleIsValid && descriptionIsValid
        }
        
        return Output(isNextButtonEnabled: isNextButtonEnabled.asDriver(onErrorJustReturn: false))
    }
}
