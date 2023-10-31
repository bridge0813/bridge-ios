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
        let selectedRestrictions: Driver<Set<String>>
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
        let selectedRestrictions = BehaviorRelay<Set<String>>(value: [])
        
        input.selectedRestriction
            .subscribe(onNext: { restriction in
                var restrictions = selectedRestrictions.value
                
                if restrictions.contains(restriction) { restrictions.remove(restriction) }
                else { restrictions.insert(restriction) }
                
                selectedRestrictions.accept(restrictions)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dataStorage.updateApplicantRestriction(with: selectedRestrictions.value.map { $0 })
                owner.coordinator?.showProjectDatePickerViewController()
            })
            .disposed(by: disposeBag)
        
        return Output(
            selectedRestrictions: selectedRestrictions.asDriver(onErrorJustReturn: [])
        )
    }
}
