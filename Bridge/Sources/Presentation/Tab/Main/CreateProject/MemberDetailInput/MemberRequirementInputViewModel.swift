//
//  MemberDetailInputViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift
import RxCocoa

final class MemberRequirementInputViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let viewDidLoad: Observable<Void>
        let nextButtonTapped: Observable<Void>
        let recruitNumberButtonTapped: Observable<Int>
        let skillTagButtonTapped: Observable<[String]>
        let requirementsTextChanged: Observable<String>
    }
    
    struct Output {
        let selectedField: Driver<String>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    private var selectedFields: [String]
    private var memberRequirements: [MemberRequirement]
    private var memberRequirement = MemberRequirement(field: "", recruitNumber: 0, requiredSkills: [], expectation: "")
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator,
        selectedFields: [String],
        memberRequirements: [MemberRequirement]
    ) {
        self.coordinator = coordinator
        self.selectedFields = selectedFields
        self.memberRequirements = memberRequirements
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.memberRequirement.field = owner.selectedFields[0]
            })
            .disposed(by: disposeBag)
        
        input.recruitNumberButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, num in
                owner.memberRequirement.recruitNumber = num
            })
            .disposed(by: disposeBag)
        
        input.skillTagButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, skills in
                owner.memberRequirement.requiredSkills = skills
            })
            .disposed(by: disposeBag)
        
        input.requirementsTextChanged
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.memberRequirement.expectation = text
            })
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.memberRequirements.append(owner.memberRequirement)
                
                owner.selectedFields.removeFirst()
                
                if owner.selectedFields.isEmpty {
                    owner.coordinator?.showApplicantRestrictionViewController(
                        with: owner.memberRequirements
                    )
                } else {
                    owner.coordinator?.showMemberRequirementInputViewController(
                        with: owner.selectedFields,
                        memberRequirements: owner.memberRequirements
                    )
                }
            })
            .disposed(by: disposeBag)
        
        let selectedField = input.viewDidLoad
            .withUnretained(self)
            .map { owner, _ in
                return owner.selectedFields.first ?? ""
            }
            .asDriver(onErrorJustReturn: "")
        
        return Output(selectedField: selectedField)
    }
}

extension MemberRequirementInputViewModel {
    
}
