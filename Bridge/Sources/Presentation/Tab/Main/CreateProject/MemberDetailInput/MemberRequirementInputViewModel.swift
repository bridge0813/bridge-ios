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
    private var memberRequirement = MemberRequirement(part: "", num: 0, skills: [], requirement: "")
    
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
                owner.memberRequirement.part = owner.selectedFields[0]
            })
            .disposed(by: disposeBag)
        
        input.recruitNumberButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, num in
                owner.memberRequirement.num = num
            })
            .disposed(by: disposeBag)
        
        input.skillTagButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, skills in
                owner.memberRequirement.skills = skills
            })
            .disposed(by: disposeBag)
        
        input.requirementsTextChanged
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.memberRequirement.requirement = text
            })
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                /// 입력한 데이터를 배열에 추가.
                owner.memberRequirements.append(owner.memberRequirement)
                
                /// 현재 해당되는 분야를 삭제
                owner.selectedFields.removeFirst()
                
                /// 더 설정할 모집 분야가 없다면 다음 뷰로 이동, 있다면 다시 설정 뷰
                if owner.selectedFields.isEmpty {
                    owner.coordinator?.showApplicantRestrictionViewController(
                        memberRequirements: owner.memberRequirements
                    )
                    
                } else {
                    owner.coordinator?.showMemberRequirementInputViewController(
                        for: owner.selectedFields,
                        memberRequirements: owner.memberRequirements
                    )
                }
            })
            .disposed(by: disposeBag)
        
        /// 선택된 분야들 중 가장 첫 번째만 가져옴.
        let selectedField = Observable.just(selectedFields.first ?? "").asDriver(onErrorJustReturn: "")
        
        return Output(selectedField: selectedField)
    }
}

extension MemberRequirementInputViewModel {
    
}
