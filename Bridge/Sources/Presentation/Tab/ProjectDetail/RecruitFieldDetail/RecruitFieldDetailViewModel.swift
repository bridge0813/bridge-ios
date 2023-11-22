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
        let projectDetail: Driver<Project>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: ProjectDetailCoordinator?
    private var project: Project
    
    // MARK: - Init
    init(
        coordinator: ProjectDetailCoordinator,
        project: Project
    ) {
        self.coordinator = coordinator
        self.project = project
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        
        return Output(
            projectDetail: Observable.just(project).asDriver(onErrorJustReturn: Project.onError)
        )
    }
}

// MARK: - Data source
extension RecruitFieldDetailViewModel {
    enum Section: CaseIterable {
        case main
    }
}
