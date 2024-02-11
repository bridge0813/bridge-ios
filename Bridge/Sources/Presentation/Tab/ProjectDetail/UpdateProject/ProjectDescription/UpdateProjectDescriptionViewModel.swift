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
    private let updateProjectUseCase: UpdateProjectUseCase
    
    // MARK: - Init
    init(
        coordinator: UpdateProjectCoordinator,
        dataStorage: ProjectDataStorage,
        updateProjectUseCase: UpdateProjectUseCase
    ) {
        self.coordinator = coordinator
        self.dataStorage = dataStorage
        self.updateProjectUseCase = updateProjectUseCase
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
        
        
        // 수정 요청
        input.nextButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ in
                // 데이터 수정
                owner.dataStorage.updateTitle(with: updatedTitle)
                owner.dataStorage.updateDescription(with: updatedDescription)
                
                // 업데이트 요청
                return owner.updateProjectUseCase.update(project: owner.dataStorage.currentProject).toResult()
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    owner.coordinator?.finish()
                    
                case .failure(let error):
                    let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                    
                    owner.coordinator?.showErrorAlert(configuration: ErrorAlertConfiguration(
                        title: "모집글 수정에 실패했습니다.",
                        description: errorMessage
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            existingTitle: .just(updatedTitle).asDriver(),
            existingDescription: .just(updatedDescription).asDriver(),
            isNextButtonEnabled: isNextButtonEnabled.asDriver(onErrorJustReturn: false)
        )
    }
}
