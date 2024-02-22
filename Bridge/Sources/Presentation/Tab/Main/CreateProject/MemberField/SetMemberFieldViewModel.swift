//
//  SetMemberFieldViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift
import RxCocoa

final class SetMemberFieldViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let dismissButtonTapped: ControlEvent<Void>
        let fieldTagButtonTapped: Observable<String>
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
        let nextButtonEnabled = BehaviorSubject<Bool>(value: false)
        var selectedFields: [String] = []
        
        input.dismissButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.finish()
            })
            .disposed(by: disposeBag)
        
        input.fieldTagButtonTapped
            .subscribe(onNext: { field in
                if let index = selectedFields.firstIndex(of: field) {
                    selectedFields.remove(at: index)
                    
                } else {
                    selectedFields.append(field)
                }
                
                nextButtonEnabled.onNext(!selectedFields.isEmpty)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dataStorage.removeAllMemberRequirements()  // 기존에 저장되었던 데이터 제거.
                owner.coordinator?.showSetMemberRequirementViewController(with: selectedFields)
            })
            .disposed(by: disposeBag)
        
        return Output(isNextButtonEnabled: nextButtonEnabled.asDriver(onErrorJustReturn: true))
    }
}
