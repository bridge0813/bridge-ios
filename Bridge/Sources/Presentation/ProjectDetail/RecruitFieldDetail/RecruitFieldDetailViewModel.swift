//
//  RecruitFieldDetailViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/13.
//

import RxSwift
import RxCocoa

final class RecruitFieldDetailViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        
    }
    
    struct Output {
        let requirements: Driver<[MemberRequirement]>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ProjectDetailCoordinator?
    private var requirements: [MemberRequirement]
    
    // MARK: - Init
    init(
        coordinator: ProjectDetailCoordinator,
        requirements: [MemberRequirement]
    ) {
        self.coordinator = coordinator
        self.requirements = requirements
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        
        return Output(
            requirements: Observable.just(requirements).asDriver(onErrorJustReturn: [])
        )
    }
}

// MARK: - Data source
extension RecruitFieldDetailViewModel {
    enum Section: CaseIterable {
        case main
    }
}
