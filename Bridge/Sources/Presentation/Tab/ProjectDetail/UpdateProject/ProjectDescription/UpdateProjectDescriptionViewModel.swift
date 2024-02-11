//
//  UpdateProjectDescriptionViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2/11/24.
//

import RxSwift
import RxCocoa

final class UpdateProjectDescriptionViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let titleTextChanged: Observable<String>
        let descriptionTextChanged: Observable<String>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let existingTitle: Driver<String>
        let existingDescription: Driver<String>
        let isNextButtonEnabled: Driver<Bool>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: UpdateProjectCoordinator?
    
    private let dataStorage: ProjectDataStorage
    
    // MARK: - Init
    init(
        coordinator: UpdateProjectCoordinator,
        dataStorage: ProjectDataStorage
    ) {
        self.coordinator = coordinator
        self.dataStorage = dataStorage
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        var updatedTitle = dataStorage.currentProject.title
        var updatedDescription = dataStorage.currentProject.description
        
        // 제목 수정
        input.titleTextChanged
            .subscribe(onNext: { text in
                updatedTitle = text
            })
            .disposed(by: disposeBag)
        
        // 소개 수정
        input.descriptionTextChanged
            .subscribe(onNext: { text in
                updatedDescription = text
            })
            .disposed(by: disposeBag)
        
        // 다음 버튼 활성화
        let isNextButtonEnabled = Observable.combineLatest(
            input.titleTextChanged.map { !$0.isEmpty },
            input.descriptionTextChanged.map { !$0.isEmpty }
        )
        .map { titleIsValid, descriptionIsValid in
            return titleIsValid && descriptionIsValid
        }
        
//        owner.dataStorage.updateTitle(with: text)
//        owner.dataStorage.updateDescription(with: text)
        
//        input.nextButtonTapped
//            .withUnretained(self)
//            .flatMap { owner, _ in
//                return owner.createProjectUseCase.create(project: owner.dataStorage.currentProject).toResult()
//            }
//            .observe(on: MainScheduler.instance)
//            .withUnretained(self)
//            .subscribe(onNext: { owner, result in
//                switch result {
//                case .success(let projectID):
//                    owner.coordinator?.showCompletionViewController(with: projectID)
//                    
//                case .failure(let error):
//                    let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
//                    
//                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
//                        title: "모집글 작성에 실패했습니다.",
//                        description: errorMessage
//                    ))
//                }
//            })
//            .disposed(by: disposeBag)
        
        return Output(
            existingTitle: .just(updatedTitle).asDriver(),
            existingDescription: .just(updatedDescription).asDriver(),
            isNextButtonEnabled: isNextButtonEnabled.asDriver(onErrorJustReturn: false)
        )
    }
}
