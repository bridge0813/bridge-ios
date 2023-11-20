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
    private let createProjectUseCase: CreateProjectUseCase
    
    // MARK: - Init
    init(
        coordinator: CreateProjectCoordinator,
        dataStorage: ProjectDataStorage,
        createProjectUseCase: CreateProjectUseCase
    ) {
        self.coordinator = coordinator
        self.dataStorage = dataStorage
        self.createProjectUseCase = createProjectUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        input.nextButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ in
                print(owner.dataStorage.currentProject)
                return owner.createProjectUseCase.create(with: owner.dataStorage.currentProject).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let projectID):
                    print("projectID: \(projectID)")
                    owner.coordinator?.showCompletionViewController()
                    
                case .failure(let error):
                    let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                    
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "모집글 작성에 실패했습니다.",
                        description: errorMessage
                    ))
                }
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
