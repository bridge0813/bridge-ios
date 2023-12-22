//
//  MyFieldViewModel.swift
//  Bridge
//
//  Created by 정호윤 on 12/14/23.
//

import RxSwift
import RxCocoa

final class MyFieldViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let fieldTagButtonTapped: Observable<String>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let isCompleteButtonEnabled: Driver<Bool>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: MyPageCoordinator?
    private let changeFieldUseCase: ChangeFieldUseCase
    
    // MARK: - Init
    init(coordinator: MyPageCoordinator?, changeFieldUseCase: ChangeFieldUseCase) {
        self.coordinator = coordinator
        self.changeFieldUseCase = changeFieldUseCase
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let completeButtonEnabled = BehaviorSubject<Bool>(value: false)
        var selectedFields: [String] = []
        
        input.fieldTagButtonTapped
            .subscribe(onNext: { field in
                if let index = selectedFields.firstIndex(of: field) {
                    selectedFields.remove(at: index)
                } else {
                    selectedFields.append(field)
                }
                
                completeButtonEnabled.onNext(!selectedFields.isEmpty)
            })
            .disposed(by: disposeBag)
        
        input.completeButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.changeFieldUseCase.changeField(selectedFields: selectedFields)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.coordinator?.showAlert(
                        configuration: .fieldChanged,
                        primaryAction: {
                            owner.coordinator?.pop()
                        }, cancelAction: {
                            owner.coordinator?.pop()
                        })
                },
                onError: { owner, _ in
                    owner.coordinator?.showErrorAlert(configuration: .defaultError) {
                        owner.coordinator?.pop()
                    }
                }
            )
            .disposed(by: disposeBag)
        
        return Output(
            isCompleteButtonEnabled: completeButtonEnabled.asDriver(onErrorJustReturn: true)
        )
    }
}
