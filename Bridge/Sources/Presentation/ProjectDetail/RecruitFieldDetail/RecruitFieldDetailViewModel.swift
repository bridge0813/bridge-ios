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
        let projectDetail: Driver<ProjectDetail>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ProjectDetailCoordinator?
    private var projectDetail: ProjectDetail
    
    // MARK: - Init
    init(
        coordinator: ProjectDetailCoordinator,
        projectDetail: ProjectDetail
    ) {
        self.coordinator = coordinator
        self.projectDetail = projectDetail
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        
        return Output(
            projectDetail: Observable.just(projectDetail).asDriver(onErrorJustReturn: ProjectDetail.onError)
        )
    }
}

// MARK: - Data source
extension RecruitFieldDetailViewModel {
    enum Section: CaseIterable {
        case main
    }
}
