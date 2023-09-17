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
        let studentButtonTapped: Observable<String>
        let currentEmployeeButtonTapped: Observable<String>
        let jobSeekerButtonTapped: Observable<String>
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    private var memberRequirements: [MemberRequirement]
    private var tagLimit: [String] = []
    
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
            .flatMap { owner, _ in
                let project = Project(
                    id: "",
                    title: "",
                    overview: "",
                    dDays: 0,
                    dueDate: Date(),
                    memberRequirement: owner.memberRequirements,
                    tagLimit: owner.tagLimit,
                    meetingWay: "",
                    progressStatus: "",
                    userEmail: ""
                )
                return Observable.just(project)
            }
            .subscribe(
                with: self,
                onNext: { owner, project in
                    owner.coordinator?.showProjectDatePickerViewController(with: project)
                }
            )
            .disposed(by: disposeBag)
        
        input.studentButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, tag in
                if let index = owner.tagLimit.firstIndex(of: tag) {
                    owner.tagLimit.remove(at: index)
                } else {
                    owner.tagLimit.append(tag)
                }
                
                print(owner.tagLimit)
            })
            .disposed(by: disposeBag)
        
        input.currentEmployeeButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, tag in
                if let index = owner.tagLimit.firstIndex(of: tag) {
                    owner.tagLimit.remove(at: index)
                } else {
                    owner.tagLimit.append(tag)
                }
                
                print(owner.tagLimit)
            })
            .disposed(by: disposeBag)
        
        input.jobSeekerButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, tag in
                if let index = owner.tagLimit.firstIndex(of: tag) {
                    owner.tagLimit.remove(at: index)
                } else {
                    owner.tagLimit.append(tag)
                }
                
                print(owner.tagLimit)
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
