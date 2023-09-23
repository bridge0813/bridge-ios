//
//  ProjectDatePickerViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import Foundation
import RxSwift
import RxCocoa

final class ProjectDatePickerViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let nextButtonTapped: Observable<Void>
        let dueDatePickerChanged: Observable<Date>
        let startDatePickerChanged: Observable<Date?>
        let endDatePickerChanged: Observable<Date?>
    }
    
    struct Output {
        let dueDate: Driver<Date>
        let startDate: Driver<Date?>
        let endDate: Driver<Date?>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    private let dataStore: ProjectDataStore
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator,
        dataStore: ProjectDataStore
    ) {
        self.coordinator = coordinator
        self.dataStore = dataStore
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.dueDatePickerChanged
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.dataStore.updateRecruitmentDeadline(with: date)
            })
            .disposed(by: disposeBag)
        
        input.startDatePickerChanged
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.dataStore.updateStartDate(with: date)
            })
            .disposed(by: disposeBag)
        
        input.endDatePickerChanged
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.dataStore.updateEndDate(with: date)
            })
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.coordinator?.showProjectProgressStatusViewController()
                }
            )
            .disposed(by: disposeBag)
        
        return Output(
            dueDate: input.dueDatePickerChanged.asDriver(onErrorJustReturn: Date()),
            startDate: input.startDatePickerChanged.asDriver(onErrorJustReturn: nil),
            endDate: input.endDatePickerChanged.asDriver(onErrorJustReturn: nil)
        )
    }
}
