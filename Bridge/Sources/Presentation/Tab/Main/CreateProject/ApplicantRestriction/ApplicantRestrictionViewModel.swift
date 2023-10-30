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
        let isNextButtonEnabled: Driver<Bool>
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
        let nextButtonEnabled = BehaviorSubject<Bool>(value: false)
        var selectedRestriction: Set<String> = []
        
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dataStorage.updateApplicantRestriction(with: selectedRestriction.map { $0 })
                owner.coordinator?.showProjectDatePickerViewController()
            })
            .disposed(by: disposeBag)
        
        input.selectedRestriction
            .subscribe(onNext: { restriction in
                if selectedRestriction.contains(restriction) { selectedRestriction.remove(restriction) }
                else { selectedRestriction.insert(restriction) }
                
                nextButtonEnabled.onNext(!selectedRestriction.isEmpty)
            })
            .disposed(by: disposeBag)
        
        return Output(isNextButtonEnabled: nextButtonEnabled.asDriver(onErrorJustReturn: true))
    }
}
