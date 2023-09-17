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
        let nextButtonTapped: Observable<Void>
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
        setFieldRequirement()
        
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
    // 임시
    private func setFieldRequirement() {
        memberRequirement = MemberRequirement(
            part: selectedFields[0],
            num: 2,
            skills: ["Swift", "UIKit", "MVVM"],
            requirement: "성실한 분들"
        )
    }
}
