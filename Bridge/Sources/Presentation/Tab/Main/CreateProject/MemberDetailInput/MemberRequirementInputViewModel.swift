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
    private var memberRequirement = MemberRequirement(field: "", recruitNumber: 0, requiredSkills: [], expectation: "")
    private let dataStore: ProjectDataStore
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator,
        selectedFields: [String],
        dataStore: ProjectDataStore
    ) {
        self.coordinator = coordinator
        self.selectedFields = selectedFields
        self.dataStore = dataStore
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        let selectedField = input.viewDidLoad
            .withUnretained(self)
            .map { owner, _ in
                let field = owner.selectedFields[0]
                owner.selectedFields.removeFirst()     
                owner.memberRequirement.field = field
                return field
            }
            .asDriver(onErrorJustReturn: "")
        
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
                owner.dataStore.updateMemberRequirements(with: owner.memberRequirement)
                
                if owner.selectedFields.isEmpty {
                    owner.coordinator?.showApplicantRestrictionViewController()
                    
                } else {
                    owner.coordinator?.showMemberRequirementInputViewController(
                        with: owner.selectedFields
                    )
                }
            })
            .disposed(by: disposeBag)
        
        return Output(selectedField: selectedField)
    }
}

extension MemberRequirementInputViewModel {
    
}
