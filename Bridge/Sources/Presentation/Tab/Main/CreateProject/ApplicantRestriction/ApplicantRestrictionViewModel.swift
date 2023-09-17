//
//  ApplicantRestrictionViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/14.
//

import Foundation
import RxSwift
import RxCocoa

final class ApplicantRestrictionViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        let nextButtonTapped: Observable<Void>
        let restrictionTagButtonTapped: Observable<RestrictionTagType>
    }
    
    struct Output {
        let restrictionTag: Driver<RestrictionTagType>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    private var memberRequirements: [MemberRequirement]
    private var tagLimit: [RestrictionTagType] = []
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator,
        memberRequirements: [MemberRequirement]
    ) {
        self.coordinator = coordinator
        self.memberRequirements = memberRequirements
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.nextButtonTapped
            .withUnretained(self)
            .map { owner, _ in
                return Project(
                    id: "",
                    title: "",
                    description: "",
                    dDays: 0,
                    recruitmentDeadline: Date(),
                    memberRequirements: owner.memberRequirements,
                    applicantRestrictions: owner.tagLimit.map { $0.rawValue },
                    progressMethod: "",
                    progressStatus: "",
                    userEmail: ""
                )
            }
            .subscribe(
                with: self,
                onNext: { owner, project in
                    owner.coordinator?.showProjectDatePickerViewController(with: project)
                }
            )
            .disposed(by: disposeBag)
        
        let restrictionTag = input.restrictionTagButtonTapped
            .withUnretained(self)
            .flatMap { owner, type in
                if let index = owner.tagLimit.firstIndex(of: type) {
                    owner.tagLimit.remove(at: index)
                } else {
                    owner.tagLimit.append(type)
                }
                
                return Observable.just(type)
            }
            .asDriver(onErrorJustReturn: RestrictionTagType.student)
        
        
        return Output(
            restrictionTag: restrictionTag
        )
    }
}

extension ApplicantRestrictionViewModel {
    enum RestrictionTagType: String {
        case student = "학생"
        case currentEmployee = "현직자"
        case jobSeeker = "취준생"
    }
}
