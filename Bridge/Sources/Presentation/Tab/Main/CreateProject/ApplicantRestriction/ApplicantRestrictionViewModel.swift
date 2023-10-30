//
//  ApplicantRestrictionViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/14.
//

import Foundation
import RxSwift
import RxCocoa

final class ApplicantRestrictionViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let selectedRestriction: Observable<String>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let selectedRestriction: Driver<String>
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
        let selectedRestriction = BehaviorRelay<String>(value: "제한없음")
        
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dataStorage.updateApplicantRestriction(with: selectedRestriction.value)
                owner.coordinator?.showProjectDatePickerViewController()
            })
            .disposed(by: disposeBag)
        
        input.selectedRestriction
            .bind(to: selectedRestriction)
            .disposed(by: disposeBag)
            
        return Output(
            selectedRestriction: selectedRestriction.asDriver())
    }
}
