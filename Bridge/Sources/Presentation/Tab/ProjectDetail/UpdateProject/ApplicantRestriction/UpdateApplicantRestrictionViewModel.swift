//
//  UpdateApplicantRestrictionViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2/10/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UpdateApplicantRestrictionViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let selectedRestriction: Observable<String>
        let nextButtonTapped: Observable<Void>
    }

    struct Output {
        let selectedRestrictions: Driver<[String]>
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
        let selectedRestrictions = BehaviorRelay<[String]>(
            value: dataStorage.currentProject.applicantRestrictions
        )

        input.selectedRestriction
            .subscribe(onNext: { restriction in
                var updatedRestrictions = selectedRestrictions.value

                if let index = updatedRestrictions.firstIndex(of: restriction) {
                    updatedRestrictions.remove(at: index)
                
                } else {
                    updatedRestrictions.append(restriction)
                }

                selectedRestrictions.accept(updatedRestrictions)
            })
            .disposed(by: disposeBag)

        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dataStorage.updateApplicantRestriction(with: selectedRestrictions.value)

            })
            .disposed(by: disposeBag)

        return Output(
            selectedRestrictions: selectedRestrictions.asDriver()
        )
    }
}
