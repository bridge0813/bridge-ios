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
    // MARK: - Input & Output
    struct Input {
        let date: Observable<(type: String, date: Date)>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let date: Driver<(type: String, date: Date)>
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
        let date = input.date
            .do(onNext: { [weak self] result in
                guard let self else { return }
                let dateString = result.date.toString(format: "yyyy-MM-dd")
                
                switch result.type {
                case "deadline": self.dataStorage.updateDeadline(with: dateString)
                case "start": self.dataStorage.updateStartDate(with: dateString)
                case "end": self.dataStorage.updateEndDate(with: dateString)
                default: return
                }
            })
        
        input.nextButtonTapped
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.coordinator?.showProjectProgressStatusViewController()
                }
            )
            .disposed(by: disposeBag)
        
        return Output(
            date: date.asDriver(onErrorJustReturn: ("", Date()))
        )
    }
}
