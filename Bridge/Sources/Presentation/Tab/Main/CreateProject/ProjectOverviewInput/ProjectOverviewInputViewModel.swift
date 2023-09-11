//
//  ProjectOverviewInputViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift

final class ProjectOverviewInputViewModel: ViewModelType {
    // MARK: - Nested Types
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    
    // MARK: - Initializer
    init(
        coordinator: CreateProjectCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        return Output()
    }
}
