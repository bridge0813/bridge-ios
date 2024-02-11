//
//  UpdateProjectScheduleViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2/10/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UpdateProjectScheduleViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let changedDate: Observable<(type: String, date: Date)>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let deadlineDate: Driver<Date>
        let startDate: Driver<Date?>
        let endDate: Driver<Date?>
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
        let deadlineDateRelay = BehaviorRelay<Date>(value: dataStorage.currentProject.deadline)
        let startDateRelay = BehaviorRelay<Date?>(value: dataStorage.currentProject.startDate)
        let endDateRelay = BehaviorRelay<Date?>(value: dataStorage.currentProject.endDate)
        
        input.changedDate
            .subscribe(onNext: { result in
                switch result.type {
                case "deadline": deadlineDateRelay.accept(result.date)
                case "start": startDateRelay.accept(result.date)
                case "end": endDateRelay.accept(result.date)
                default: return
                }
            })
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dataStorage.updateDeadline(with: deadlineDateRelay.value)
                owner.dataStorage.updateStartDate(with: startDateRelay.value)
                owner.dataStorage.updateEndDate(with: endDateRelay.value)
                owner.coordinator?.showUpdateProjectProgressStatusViewController()
            })
            .disposed(by: disposeBag)
        
        return Output(
            deadlineDate: deadlineDateRelay.asDriver(),
            startDate: startDateRelay.asDriver(),
            endDate: endDateRelay.asDriver()
        )
    }
}
