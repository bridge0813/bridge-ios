//
//  UpdateProjectProgressViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2/11/24.
//

import RxSwift
import RxCocoa

final class UpdateProjectProgressViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let progressMethodButtonTapped: Observable<String>
        let progressStep: Observable<String>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let progressMethod: Driver<String>
        let progressStep: Driver<String>
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
        let progressMethod = BehaviorRelay<String>(value: dataStorage.currentProject.progressMethod)
        let progressStep = BehaviorRelay<String>(value: dataStorage.currentProject.progressStep)
        
        // 진행 방식
        input.progressMethodButtonTapped
            .subscribe(onNext: { method in
                progressMethod.accept(method)
            })
            .disposed(by: disposeBag)
        
        // 진행 단계
        input.progressStep
            .subscribe(onNext: { step in
                progressStep.accept(step)
            })
            .disposed(by: disposeBag)
                
        // 다음 이동
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dataStorage.updateProgressMethod(with: progressMethod.value)
                owner.dataStorage.updateProgressStep(with: progressStep.value)
                owner.coordinator?.showUpdateProjectDescriptionViewController()
            })
            .disposed(by: disposeBag)
                
        return Output(
            progressMethod: progressMethod.asDriver(onErrorJustReturn: ""),
            progressStep: progressStep.asDriver(onErrorJustReturn: "")
        )
    }
}
