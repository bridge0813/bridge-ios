//
//  UpdateMemberRequirementViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2/9/24.
//

import RxSwift
import RxCocoa

final class UpdateMemberRequirementViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let viewDidLayoutSubviews: Observable<Void>
        let recruitNumber: Observable<Int>
        let techTags: Observable<[String]>
        let requirementText: Observable<String>
        let nextButtonTapped: Observable<Void>
    }

    struct Output {
        let currentMemberRequirement: Driver<MemberRequirement>
        let isNextButtonEnabled: Driver<Bool>
    }

    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: UpdateProjectCoordinator?

    private var selectedFields: [String]
    private let dataStorage: ProjectDataStorage

    // MARK: - Init
    init(
        coordinator: UpdateProjectCoordinator,
        selectedFields: [String],
        dataStorage: ProjectDataStorage
    ) {
        self.coordinator = coordinator
        self.selectedFields = selectedFields
        self.dataStorage = dataStorage
    }

    // MARK: - Transformation
    func transform(input: Input) -> Output {
        // 현재 세부사항을 작성하려는 분야(카운팅을 위해 사용)
        let field = selectedFields[0]
        selectedFields.removeFirst()

        let currentRequirementRelay = BehaviorRelay<MemberRequirement>(
            value: MemberRequirement(field: field, recruitNumber: 0, requiredSkills: [], requirementText: "")
        )

        // 레이아웃이 완성된 시점에 데이터 방출
        input.viewDidLayoutSubviews
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                // 현재 수정하려는 분야에 맞는 requirement를 가져오기.
                let currentRequirement =
                owner.dataStorage.currentProject.memberRequirements.first(where: { $0.field == field })
                ?? MemberRequirement(field: field, recruitNumber: 0, requiredSkills: [], requirementText: "")
                currentRequirementRelay.accept(currentRequirement)
            })
            .disposed(by: disposeBag)

        // 모집 인원 수정
        input.recruitNumber
            .subscribe(onNext: { number in
                var updatedValue = currentRequirementRelay.value
                updatedValue.recruitNumber = number
                currentRequirementRelay.accept(updatedValue)
            })
            .disposed(by: disposeBag)

        // 기술 태그 수정
        input.techTags
            .subscribe(onNext: { tags in
                var updatedValue = currentRequirementRelay.value
                updatedValue.requiredSkills = tags
                currentRequirementRelay.accept(updatedValue)
            })
            .disposed(by: disposeBag)

        // 바라는 점 수정
        input.requirementText
            .subscribe(onNext: { text in
                var updatedValue = currentRequirementRelay.value
                updatedValue.requirementText = text
                currentRequirementRelay.accept(updatedValue)
            })
            .disposed(by: disposeBag)

        // 다음 버튼 클릭
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dataStorage.updateMemberRequirements(with: currentRequirementRelay.value)

                // 더 이상 작성할 분야가 없다면, 다음 스텝으로 이동
                // 있다면, 현재 스텝 다시 한 번 보여주기
                if owner.selectedFields.isEmpty {
                    owner.coordinator?.showUpdateApplicantRestrictionViewController()
                } else {
                    owner.coordinator?.showUpdateMemberRequirementViewController(
                        selectedFields: owner.selectedFields
                    )
                }
            })
            .disposed(by: disposeBag)

        // 다음 버튼 활성화 여부
        let isNextButtonEnabled = Observable.combineLatest(
            input.recruitNumber.map { $0 > 0 },
            input.techTags.map { !$0.isEmpty },
            input.requirementText.map { !$0.isEmpty }
        )
        .map { recruitNumberIsValid, tagIsValid, requirementTextIsValid in
            return recruitNumberIsValid && tagIsValid && requirementTextIsValid
        }

        return Output(
            currentMemberRequirement: currentRequirementRelay.asDriver(),
            isNextButtonEnabled: isNextButtonEnabled.asDriver(onErrorJustReturn: false)
        )
    }
}
