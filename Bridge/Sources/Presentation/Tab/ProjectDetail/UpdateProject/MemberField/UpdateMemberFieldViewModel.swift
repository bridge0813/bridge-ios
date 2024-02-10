//
//  UpdateMemberFieldViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2/9/24.
//

import RxSwift
import RxCocoa

final class UpdateMemberFieldViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let dismissButtonTapped: ControlEvent<Void>
        let fieldTagButtonTapped: Observable<String>
        let nextButtonTapped: Observable<Void>
    }

    struct Output {
        let selectedFields: Driver<[String]>
        let isNextButtonEnabled: Driver<Bool>
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
        let nextButtonEnabled = BehaviorSubject<Bool>(value: true)
        var selectedFields: [String] = dataStorage.currentProject.memberRequirements.map { $0.field }

        input.dismissButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.finish()
            })
            .disposed(by: disposeBag)

        input.fieldTagButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, field in
                // 이미 존재하는 요소인지 체크
                if let index = selectedFields.firstIndex(of: field) {
                    selectedFields.remove(at: index)
                    owner.dataStorage.removeMemberRequirement(for: field)

                } else {
                    selectedFields.append(field)
                    owner.dataStorage.updateMemberRequirements(with: MemberRequirement(
                        field: field, recruitNumber: 0, requiredSkills: [], requirementText: "")
                    )
                }

                nextButtonEnabled.onNext(!selectedFields.isEmpty)
            })
            .disposed(by: disposeBag)

        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in

            })
            .disposed(by: disposeBag)

        return Output(
            selectedFields: .just(selectedFields).asDriver(),
            isNextButtonEnabled: nextButtonEnabled.asDriver(onErrorJustReturn: true)
        )
    }
}
