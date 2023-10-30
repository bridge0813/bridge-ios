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
//        let restrictionTagButtonTapped: Observable<RestrictionTagType>
    }
    
    struct Output {
//        let restrictionTag: Driver<RestrictionTagType>
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    private let dataStorage: ProjectDataStorage
    private var restrictions: [RestrictionTagType] = []
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator,
        dataStorage: ProjectDataStorage
    ) {
        self.coordinator = coordinator
        self.dataStorage = dataStorage
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dataStorage.updateApplicantRestriction(with: owner.restrictions)
                owner.coordinator?.showProjectDatePickerViewController()
            })
            .disposed(by: disposeBag)
        
//        let restrictionTag = input.restrictionTagButtonTapped
//            .withUnretained(self)
//            .flatMap { owner, type in
//
//                if let index = owner.restrictions.firstIndex(of: type) {
//                    owner.restrictions.remove(at: index)
//                } else {
//                    owner.restrictions.append(type)
//                }
//
//                return Observable.just(type)
//            }
//            .asDriver(onErrorJustReturn: RestrictionTagType.student)
        
        return Output(
//            restrictionTag: restrictionTag
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
