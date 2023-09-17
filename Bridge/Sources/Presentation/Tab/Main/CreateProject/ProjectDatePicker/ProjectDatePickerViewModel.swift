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
    private var project: Project
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator,
        project: Project
    ) {
        self.coordinator = coordinator
        self.project = project
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let dueDate = BehaviorRelay<Date>(value: Date())
        let startDate = BehaviorRelay<Date?>(value: nil)
        let endDate = BehaviorRelay<Date?>(value: nil)
        
        input.dueDatePickerChanged
            .bind(to: dueDate)
            .disposed(by: disposeBag)
        
        input.startDatePickerChanged
            .bind(to: startDate)
            .disposed(by: disposeBag)
       
        input.endDatePickerChanged
            .bind(to: endDate)
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.project.dueDate = dueDate.value
                owner.project.startDate = startDate.value
                owner.project.endDate = endDate.value
                
                return Observable.just(owner.project)
            }
            .subscribe(
                with: self,
                onNext: { owner, project in
                    owner.coordinator?.showProjectProgressStatusViewController(with: project)
                }
            )
            .disposed(by: disposeBag)
        
        return Output(
            dueDate: dueDate.asDriver(onErrorJustReturn: Date()),
            startDate: startDate.asDriver(onErrorJustReturn: nil),
            endDate: endDate.asDriver(onErrorJustReturn: nil)
        )
    }
}
