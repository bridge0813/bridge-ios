//
//  SetApplicantRestrictionViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/14.
//

import Foundation
import RxSwift
import RxCocoa

final class SetApplicantRestrictionViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let selectedRestriction: Observable<String>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let selectedRestrictions: Driver<Set<String>>
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
                owner.coordinator?.showSetProjectScheduleViewController()
            })
            .disposed(by: disposeBag)
        
        return Output(
            selectedRestrictions: selectedRestrictions.asDriver(onErrorJustReturn: [])
        )
    }
}
